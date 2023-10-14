{ lib
, pkgs
, inputs
, system
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
    config.allowUnfree = true;
  };
}
