{ self, lib, flake-parts-lib, moduleLocation, ... }:

with builtins;
let
  inherit (lib) mkOption types mapAttrs;
  inherit (flake-parts-lib) mkSubmoduleOptions;

in
{
  options = {
    flake = mkSubmoduleOptions {
      homeManagerModules = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        apply = mapAttrs (k: v: {
          _class = "homeManager";
          _file = "${toString moduleLocation}#homeManagerModules.${k}";
          imports = [ v ];
        });
        description = ''
          Home Manager configuration modules
        '';
      };

      homeManagerUsers = mkOption {
        type = types.lazyAttrsOf types.deferredModule;
        default = { };
        apply = mapAttrs (k: v: {
          _class = "homeManager";
          _file = "${toString moduleLocation}#homeManagerUsers.${k}";
          imports = [ v ];
        });
        description = ''
          Home Manager user configurations
        '';
      };
    };
  };
}
