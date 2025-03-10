{ inputs, ... }@toplevel: pkgs:

with pkgs.lib;
rec {
  u1f408-x = pkgs.callPackage ./u1f408-x {};
  opencore-drivers = pkgs.callPackage ./opencore/drivers.nix {};
  remotedesktopmanager = pkgs.callPackage ./remotedesktopmanager {};

  qemu-woa = pkgs.callPackage ./qemu-woa {};
}
