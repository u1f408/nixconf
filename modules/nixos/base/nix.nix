{ _passthru
, inputs
, meta
, pkgs
, lib
, ...
}:

{
  config = {
    nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
      registry = {
        nixpkgs.flake = inputs.nixpkgs;
      };
    };

    nixpkgs = {
      overlays = [
        meta.overlays.default
      ];
    };

    systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";
  };
}
