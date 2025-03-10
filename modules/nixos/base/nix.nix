{ inputs
, config
, meta
, pkgs
, lib
, ...
}:

{
  imports = [
    inputs.lix-module.nixosModules.default
  ];

  nix = {
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
      home-manager.flake = inputs.home-manager;
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs = {
    overlays = [
      meta.overlays.default
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) system;
          inherit (config.nixpkgs) config;
        };
      })
    ];
  };

  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";
}
