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
    wlr-randr

    brightnessctl
    waypaper
    swaybg
    sfwbar
    yambar
    bemenu
    mako    
    wofi
    grim
  ];
}
