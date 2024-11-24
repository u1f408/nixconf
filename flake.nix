{
  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; moduleLocation = ./flake.nix; }
    ({ ... }:
      let
        std = import ./std { inherit inputs; };

      in
      {
        systems = [ "x86_64-linux" ];
        imports = [
          ./std/flake-module.nix
          ./systems
        ];

        flake = {
          nixosModules = std.importSubdirs { baseDir = ./modules/nixos; };
          homeModules = std.importSubdirs { baseDir = ./modules/home; };
          homeConfigurations = std.importSubdirs { baseDir = ./users; };
          overlays.default = import ./packages/overlay.nix { inherit inputs; };
        };

        perSystem = { pkgs, ... }: {
          packages = import ./packages { inherit inputs; } pkgs;
        };
      });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
}
