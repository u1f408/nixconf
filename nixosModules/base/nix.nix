{ _passthru
, meta
, config
, inputs
, pkgs
, lib
, ...
}:

with lib;
let
  cfg = config.iris;

in
{
  options.iris = {
    allowUnfreePackages = mkOption {
      default = [];
      type = types.listOf types.str;

      description = ''
        List of package names to match in `nixpkgs.config.allowUnfreePredicate`
      '';
    };

    allowInsecurePackages = mkOption {
      default = [];
      type = types.listOf types.str;

      description = ''
        List of package names to match in `nixpkgs.config.allowInsecurePredicate`
      '';
    };
  };

  config = {
    nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
      registry.nixpkgs.flake = inputs.nixpkgs;
      registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    };

    nixpkgs = {
      overlays = [
        meta.overlays.default

        (final: _prev: {
          unstable = import inputs.nixpkgs-unstable {
            system = _passthru.system;
          };
        })
      ];

      config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) cfg.allowUnfreePackages;
      config.allowInsecurePredicate = pkg: builtins.elem (getName pkg) cfg.allowInsecurePackages;
    };

    systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";
  };
}
