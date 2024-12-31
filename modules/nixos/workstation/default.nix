{ pkgs
, lib
, ...
}:

{
  imports = [
    ./networking.nix
    ./security.nix
    ./displayManager.nix
  ];

  time.timeZone = "Pacific/Auckland";

  # programs.labwc.enable = true;
  services.libinput.enable = true;
  services.xserver.enable = true;
  services.displayManager.defaultSession = "xfce";
  services.xserver.desktopManager.xfce.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.enable = true;

  services.upower.enable = true;
}
