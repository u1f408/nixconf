{ meta
, pkgs
, lib
, ...
}:

{
  programs.labwc.enable = true;
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    xfce.xfce4-terminal
    labwc-tweaks
    wl-clipboard
    wtype

    brightnessctl
    wlr-randr
    kanshi
    wvkbd

    chayang
    swayidle
    swaylock
    wlopm

    swaybg
    yambar
    mako    
    wofi

    grim
    slurp
    swappy
  ];
}
