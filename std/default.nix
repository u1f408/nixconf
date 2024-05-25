{ inputs
, ...
}:

with builtins;
with inputs.nixpkgs.lib;

let
  importSubdirs = { baseDir }:
    (mapAttrs'
      (name: _: nameValuePair name (import (baseDir + "/${name}")))
      (filterAttrs
        (name: ty: (ty == "directory") && (pathExists (baseDir + "/${name}/default.nix")))
        (readDir baseDir)));

  std' = {
    inherit
      importSubdirs
      ;
  };

in std'
