{ lib
, pkgs
, inputs
, system
, ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./module.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

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
