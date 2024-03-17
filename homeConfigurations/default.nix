{ inputs, ... }:

with builtins;
with inputs.nixpkgs.lib;

{
  flake.homeConfigurations = 
    (mapAttrs'
      (name: _: nameValuePair name (import (./. + "/${name}")))
      (filterAttrs
        (name: ty: (ty == "directory") && (pathExists (./. + "/${name}/default.nix")))
        (readDir ./.)));
}
