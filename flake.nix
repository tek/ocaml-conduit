{
  description = "OCaml: conduit";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { flake-utils, nixpkgs, ... }:
  let
    deps = [
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
    main = system:
    let
      pkgs = import nixpkgs { inherit system; };
      opam = "${pkgs.opam}/bin/opam";
      opamPkg = name: pkgs.writeScript "install-${name}" ''
        installed=$(${opam} show -f installed-version ${name})
        if [[ $installed == '--' ]]
        then
          ${opam} install -y ${name}
        else
          echo ${name} version: $installed
        fi
      '';
    installDeps = 
      pkgs.writeScript "install-deps" ''
        ${opam} init --no-opamrc --no-setup
        eval $(${opam} env)
        current=$(opam switch show)
        if [[ $current != "4.10" ]]
        then
          ${opam} switch create 4.10 ocaml-base-compiler.4.10.2
        fi
        eval $(${opam} env)
        ${pkgs.lib.strings.concatMapStringsSep "\n" opamPkg deps}
      '';
    in rec {
      apps = {
        install = {
          type = "app";
          program = "${installDeps}";
        };
      };
      defaultApp = apps.install;
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          bash
          bazel
          coreutils
          openssl
          gmp
          pkg-config
        ];
        shellHook = ''
          export OPAMROOT=$PWD/.opam OPAMNO=true
          if [[ ! -d $OPAMROOT ]]
          then
            nix run .#install
          fi
          eval $(${opam} env)
        '';
      };
    };
  in flake-utils.lib.eachSystem ["x86_64-linux"] main;
}
