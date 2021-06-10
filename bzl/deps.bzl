load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def conduit_deps():
    maybe(
        http_archive,
        "uri",
        sha256 = "fa732fb3ae7f97d7b6bd0506b60d3d7e6a2cf85840160a28c78b938170161d96",
        strip_prefix = "ocaml-uri-cce0f6742741e378be136baf30fecbec07c584ed",
        urls = [
            "https://github.com/tek/ocaml-uri/archive/cce0f6742741e378be136baf30fecbec07c584ed.tar.gz",
        ],
    )
