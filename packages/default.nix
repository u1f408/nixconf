{ inputs, ... }@toplevel: pkgs:

with pkgs.lib;
rec {
  remotedesktopmanager = pkgs.callPackage ./remotedesktopmanager {};

  u1f408-x = pkgs.callPackage ./u1f408-x {};
  opencore-drivers = pkgs.callPackage ./opencore/drivers.nix {};

  freerdp-wslg = pkgs.callPackage ./freerdp-wslg {};
  weston-wslg = pkgs.callPackage ./weston-wslg { inherit freerdp-wslg; };
}
