{ meta
, pkgs
, lib
, ...
}:

{
  imports = [
    meta.nixosModules.base-desktop
  ];

  services.xserver.desktopManager.xfce.enable = true;

  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    xfce.xfce4-volumed-pulse
    xfce.xfce4-pulseaudio-plugin
  ];
}
