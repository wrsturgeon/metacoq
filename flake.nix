{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rocq2rust-flake = {
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
      rocq2rust-flake,
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

        rocq2rust = rocq2rust-flake.packages.${system}.default;
        deps-native = [ rocq2rust ];

        env = {
          COQBIN = "${rocq2rust}/bin";
          COQLIB = "${rocq2rust}/lib";
          DUNEOPT = "--display=short";
        };

      in
      {
        devShells.default = pkgs.mkShell ({ packages = deps-native; } // env);
      }
    );
}
