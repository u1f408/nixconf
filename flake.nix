{
  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; moduleLocation = ./flake.nix; }
    ({ self, ... }:
      let
        std = import ./std { inherit inputs; };

      in
      {
        systems = [ "x86_64-linux" "aarch64-linux" ];
        imports = [
          ./std/flake-module.nix
          ./modules/flake/home-manager.nix

          ./systems
        ];

        flake = {
          nixosModules = std.importSubdirs { baseDir = ./modules/nixos; };
          homeManagerModules = std.importSubdirs { baseDir = ./modules/home; };
          homeManagerUsers = std.importSubdirs { baseDir = ./users; };
          overlays.default = import ./packages/overlay.nix { inherit inputs; };
        };

        perSystem = { pkgs, ... }: {
          packages = import ./packages { inherit inputs; } pkgs;

          legacyPackages =
            let
              homeConfigurations = (with builtins; with pkgs.lib; mapAttrs'
                (name: _: nameValuePair name (inputs.home-manager.lib.homeManagerConfiguration {
                  inherit pkgs;
                  extraSpecialArgs = { inherit inputs self; };
                  modules = [
                    self.homeManagerModules.base
                    self.homeManagerUsers."${name}"
                    ({ ... }: {
                      home.username = "${name}";
                      home.homeDirectory = "/home/${name}";
                      programs.home-manager.enable = true;
                    })
                  ];
                }))
              self.homeManagerUsers);
            in
            {
              inherit homeConfigurations;
            };
        };
      });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
}
