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
    # personal machines
    (mkNixOS "lumpy" "x86_64-linux" {})
    (mkNixOS "catdesk" "x86_64-linux" {})

    # work machines
    (mkNixOS "ghost" "x86_64-linux" {})
    (mkNixOS "arion" "x86_64-linux" {})

    # infra
    (mkNixOS "kitn-coord01" "x86_64-linux" {})

    # home servers
    (mkNixOS "kitn-hmsd-s01" "x86_64-linux" {})
    (mkNixOS "kitn-hmhv-c01" "x86_64-linux" {})
    (mkNixOS "kitn-hmhv-c02" "x86_64-linux" {})
    (mkNixOS "kitn-hmhv-c03" "x86_64-linux" {})
  ];
}
