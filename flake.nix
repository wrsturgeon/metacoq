{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rocq2rust = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nix-filter.follows = "nix-filter";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:wrsturgeon/rocq2rust";
    };
  };

  outputs =
    {
      flake-utils,
      nix-filter,
      nixpkgs,
      rocq2rust,
      self,
    }:
    let
      pname = "metarocq";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        ml-pkgs = pkgs.ocamlPackages;

        deps-native =
          (with pkgs; [
            dune_3
          ])
          ++ (with ml-pkgs; [
            findlib
            ocaml
            ocamlformat
            zarith
          ]);

        env = {
          DUNEOPT = "--display=short";
        };

      in
      {
        devShells.default = pkgs.mkShell ({ packages = deps-native; } // env);
      }
    );
}
