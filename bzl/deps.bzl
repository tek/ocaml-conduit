load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def conduit_deps():
    maybe(
        http_archive,
        "uri",
        sha256 = "c3501b501f76a94f3e0181f031cdcf137e5a44111e21834416af3ca250748a78",
        strip_prefix = "ocaml-uri-e2efd4143b189240c6c4b121b586827d3ebd2113",
        urls = [
            "https://github.com/tek/ocaml-uri/archive/e2efd4143b189240c6c4b121b586827d3ebd2113.tar.gz",
        ],
    )
