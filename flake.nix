{
  description = "OCaml: conduit";

  inputs.obazl.url = github:tek/rules_ocaml;

  outputs = { obazl, ... }:
  let
    extraInputs = p: [
      p.openssl
      p.gmp
    ];

    depsOpam = [
      "lwt_ssl"
      "stringext"
      "ppxlib"
      "angstrom"
      "ppx_sexp_conv"
      "ppx_deriving"
      "sexplib"
      "logs"
      "async"
      "ipaddr-sexp"
      "ipaddr"
      "tls"
      "ca-certs"
    ];

  in obazl.flakes { inherit extraInputs depsOpam; };
}
