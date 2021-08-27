{ config, lib, pkgs, ... }:

{
  imports = [ ];

  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.defaultSession = lib.mkDefault "xfce";
}
