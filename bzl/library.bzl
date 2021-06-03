load(
    "@obazl_rules_ocaml//ocaml:rules.bzl",
    "ocaml_library",
    "ocaml_module",
    "ocaml_signature",
    "ppx_module",
    "ppx_library",
    "ppx_ns_library",
)

def sig_module(name, conf, deps, ppx = False, **kw):
    struct = conf.get("mod", name + ".ml")
    sig = conf.get("sig_src", name + "_sig" if conf.get("sig", False) else None)
    all_deps = deps + conf.get("deps", [])
    if sig != None:
        ocaml_signature(
            name = sig,
            src = conf.get("sig_src", name + ".mli"),
            deps = all_deps,
            **kw,
        )
    cons = ppx_module if ppx else ocaml_module
    cons(
        name = name,
        struct = struct,
        deps = all_deps,
        sig = sig,
        **kw,
    )
    return name

def lib(modules, name = "lib", deps = [], ppx = False, ns = False, **kw):
    targets = [sig_module(mod_name, conf, deps, ppx = ppx, **kw) for (mod_name, conf) in modules.items()]
    cons = (ppx_ns_library if ns else ppx_library) if ppx else ocaml_library
    mods = dict(submodules = targets) if ns else dict(modules = targets)
    cons(
        name = name,
        visibility = ["//visibility:public"],
        **mods,
    )

def simple_lib(modules, sig = True, **kw):
    targets = dict([(name, dict(deps = deps, sig = sig)) for (name, deps) in modules.items()])
    return lib(targets, **kw)

def sig(*deps, **kw):
    return dict(sig = True, deps = list(deps), **kw)

def mod(*deps, **kw):
    return dict(deps = list(deps), **kw)
