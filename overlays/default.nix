{ inputs, system ? builtins.currentSystem, ... }@args:

let
  pkgs = import inputs.nixpkgs {
    inherit system;

    overlays = [
      (import ./lib)
      inputs.nur.overlay

      (final: prev: rec {
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
            allowBroken = true;
          };
        };
      })
    ];

    config = {
      allowUnfree = true;
    };
  };

in pkgs
