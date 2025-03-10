{ config
, pkgs
, lib
, ...
}:

with lib;

{
  environment.systemPackages = mkMerge [
    (mkIf config.services.displayManager.enable (with pkgs;[
      virt-manager
    ]))

    (mkIf config.services.xserver.desktopManager.gnome.enable (with pkgs; [
      gnome-boxes
    ]))
  ];
}
