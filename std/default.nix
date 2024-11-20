{ inputs, ... }@toplevel:

with builtins;
with inputs.nixpkgs.lib;

let
  importSubdirs = { baseDir }:
    (mapAttrs'
      (name: _: nameValuePair name (import (baseDir + "/${name}")))
      (filterAttrs
        (name: ty: (ty == "directory") && (pathExists (baseDir + "/${name}/default.nix")))
        (readDir baseDir)));

  systems = import ./systems.nix toplevel;

  std' = {
    inherit
      importSubdirs
      ;

    inherit (systems)
      mkNixOS
      ;
  };

in std'
