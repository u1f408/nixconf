{ _passthru
, inputs
, pkgs
, ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.default

    ./packages.nix
    ./networking.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
  };

  nixpkgs.overlays = [
    (final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = _passthru.system;
      };
    })
  ];
}
