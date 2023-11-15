{ lib
, pkgs
, inputs
, system
, config
, ...
}:

{
  imports = [
    ./hm.nix
    ./packages.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };
  };

  nixpkgs = {
    hostPlatform = system;
    overlays = with inputs; [
      nur.overlay
    ];

    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];

      packageOverrides = pkgs: {
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = config.nixpkgs.config;
        };
      };
    };
  };
}
