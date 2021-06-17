load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def conduit_deps():
    maybe(
        http_archive,
        "uri",
        sha256 = "fba8bc7e9f16a9ecc5a20d877661d86949667caaa7c079468b134468f54c0a8e",
        strip_prefix = "ocaml-uri-7d64ad6ead5af1e6e685391495406ae19141e8bf",
        urls = [
            "https://github.com/tek/ocaml-uri/archive/7d64ad6ead5af1e6e685391495406ae19141e8bf.tar.gz",
        ],
    )
