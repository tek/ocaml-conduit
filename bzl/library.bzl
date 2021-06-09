load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load(
    "@obazl_rules_ocaml//ocaml:rules.bzl",
    "ocaml_library",
    "ocaml_module",
    "ocaml_ns_library",
    "ocaml_signature",
    "ppx_library",
    "ppx_module",
    "ppx_executable",
    "ppx_ns_library",
)

def copy_interface(name, out):
    copy_file(
        name = name + "_mli",
        src = name + ".mli",
        out = "__obazl/" + out + ".mli",
    )

def ppx_args(name, tags = []):
    return dict(
        ppx = ":ppx_" + name,
        ppx_print = "@ppx//print:text",
        ppx_tags = [],
    )

def sig_module(name, conf, deps = [], ppx = False, **kw):
    use_ppx = "ppx" in conf
    struct = conf.get("mod", name + ".ml")
    sig = name if conf.get("sigonly", False) else conf.get("sig_src", name + "_sig" if conf.get("sig", False) else None)
    all_deps = deps + conf.get("deps", [])
    if sig != None:
        ocaml_signature(
            name = sig,
            src = conf.get("sig_src", name + ".mli"),
            deps = all_deps,
            **kw
        )
    ppx_kw = ppx_args(**conf["ppx"]) if use_ppx else dict()
    kw.update(ppx_kw)
    cons = ppx_module if ppx else ocaml_module
    if not conf.get("sigonly"):
        cons(
            name = name,
            struct = struct,
            deps = all_deps,
            sig = sig,
            **kw,
        )
    return name

def ppx_exe(ident, deps):
    ppx_executable(
        name = "ppx_" + ident,
        deps_opam = deps,
        main = "//bzl:ppx_driver",
    )

def lib(name, modules, ns = True, deps = [], ppx = dict(), ppx_deps = False, **kw):
    use_ppx = ppx_deps or len(ppx) != 0
    [ppx_exe(ident, deps) for (ident, deps) in ppx.items()]
    lib_name = "lib-" + name
    ns_name = "#" + name.capitalize().replace("-", "_")
    targets = [sig_module(mod_name, conf, deps, ppx = use_ppx, **kw) for (mod_name, conf) in modules.items()]
    cons = ppx_library if use_ppx else ocaml_library
    cons_ns = ppx_ns_library if use_ppx else ocaml_ns_library
    cons(
        name = lib_name,
        modules = targets,
        visibility = ["//visibility:public"],
    )
    if ns:
        cons_ns(
            name = ns_name,
            submodules = targets,
            visibility = ["//visibility:public"],
        )

def simple_lib(modules, sig = True, **kw):
    targets = dict([(name, dict(deps = deps, sig = sig)) for (name, deps) in modules.items()])
    return lib(targets, **kw)

def sig(*deps, **kw):
    return dict(sig = True, deps = list(deps), **kw)

def mod(*deps, **kw):
    return dict(deps = list(deps), **kw)

def sigonly(*deps, **kw):
    return dict(sig = True, sigonly = True, deps = list(deps), **kw)
