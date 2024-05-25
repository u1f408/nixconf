{
  outputs = { flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; moduleLocation = ./flake.nix; }
    ({ ... }:
      let
        std = import ./std { inherit inputs; };
        subdirAttrs =
          with builtins;
          with inputs.nixpkgs.lib;
          listToAttrs (map
            (x: nameValuePair x (std.importSubdirs { baseDir = ./. + "/${x}"; }))
            [ "nixosModules" "homeConfigurations" ]);

      in
      {
        systems = [ "x86_64-linux" "aarch64-linux" ];
        imports = [
          ./std/flake-module.nix
          ./nixosConfigurations
        ];

        flake = subdirAttrs // {
          overlays.default = import ./packages/overlay.nix { inherit inputs; };
        };

        perSystem = { pkgs, ... }: {
          packages = import ./packages { inherit inputs; } pkgs;
        };
      });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "nix-darwin";
      inputs.systems.follows = "systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    iris-dotcfg = {
      url = "github:u1f408/dotcfg";
      flake = false;
    };
  };
}
