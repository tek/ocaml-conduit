load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def conduit_deps():
    maybe(
        http_archive,
        "uri",
        sha256 = "3fcc7bcef1b6e7ab49d01d2c2bfff16f988f0c4dc31f1601b94abe710000a758",
        strip_prefix = "ocaml-uri-bfb001b8cc9adf6975e3c7b3cbd280f4627c353e",
        urls = [
            "https://github.com/tek/ocaml-uri/archive/bfb001b8cc9adf6975e3c7b3cbd280f4627c353e.tar.gz",
        ],
    )
