{ config ? { }, sources, system ? builtins.currentSystem, ... }@args:

let
  overlay = self: super: {
    nur = import sources.NUR {
      nurpkgs = self;
      pkgs = self;
    };

    comic-code = self.callPackage ./comic-code { };
    hikari-session = self.callPackage ./hikari-session { };
  };

  pkgs = import sources.nixpkgs {
    overlays = [
      (import (sources.nixexprs + "/overlay.nix"))
      (import (sources.arc-nixexprs + "/overlay.nix"))
      (import (sources.kat-nixexprs + "/overlay.nix"))
      (import (sources.papa-nixexprs + "/overlay.nix"))
      overlay
    ];

    config = {
      allowUnfree = true;
    };
  };

in pkgs
