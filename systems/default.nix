{ inputs
, self
, std
, ...
}:

with std;
with builtins;
with inputs.nixpkgs.lib;

{
  flake.nixosConfigurations = mkMerge [
    (mkNixOS "kitn-hmsd-s01" "x86_64-linux" {})
    (mkNixOS "kitn-hmhv-c01" "x86_64-linux" {})
    (mkNixOS "kitn-hmhv-c02" "x86_64-linux" {})
    (mkNixOS "kitn-hmhv-c03" "x86_64-linux" {})
  ];
}
