{ inputs, ... }@toplevel: pkgs:

with pkgs.lib;
{
  u1f408-x = pkgs.callPackage ./u1f408-x {};
  opencore-drivers = pkgs.callPackage ./opencore/drivers.nix {};
}