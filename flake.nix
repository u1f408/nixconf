{
  description = "Iris System's Nix configs";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, flake-utils, nixpkgs, nur, ... }@inputs:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        legacyPackages = import ./outputs.nix { inherit inputs system; };
      }
    ))
    // (let
      mkNixosSystem = hostname: system:
        let
          meta = self.legacyPackages.${system}.meta;
          pkgs = import ./overlays { inherit inputs system; };

        in nixpkgs.lib.nixosSystem rec {
          inherit system;

          specialArgs = {
            root = ./.;
            inherit inputs;
            inherit meta;
            inherit pkgs;
          };

          modules = [
            meta.modules.nixos
            meta.hosts.${hostname}
          ];
        };

    in rec {
      nixosConfigurations.triad = mkNixosSystem "triad" "x86_64-linux"; 
    });
}
