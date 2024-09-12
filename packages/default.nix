toplevel @ { inputs, ... }: pkgs:

with pkgs.lib;
let
  system = pkgs.stdenv.hostPlatform.system or pkgs.system;

in
{
  winbox4 = pkgs.callPackage ./winbox4 {};
  iris-scripts = pkgs.callPackage ./iris-scripts {};
  u1f408-x = pkgs.callPackage ./u1f408-x {};
}
