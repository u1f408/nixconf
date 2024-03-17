{ pkgs
, lib
, ...
}:

let
  ourSwaybg = pkgs.swaybg.overrideAttrs (old: rec {
    name = "swaybg-80ed4b020";
    version = "0.2.0+git80ed4b020";
    src = pkgs.fetchFromGitHub {
      owner = "swaywm";
      repo = "swaybg";
      rev = "80ed4b020adfb0846f780faba95fc5cc9a770a18";
      hash = "sha256-zfggXlN8Zly0iH5t9kBbcQyL5+NsRbHyaovNt/O9pw4=";
    };
  });

in
{
  services.xserver.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.package = pkgs.unstable.mesa.drivers;
  programs.xfconf.enable = true;
  programs.dconf.enable = true;
  programs.xwayland.enable = true;
  fonts.enableDefaultPackages = true;

  services.xserver.displayManager.sessionPackages = with pkgs; [
    unstable.miriway
  ];

  xdg.portal = {
    config.common.default = "*";
    wlr.enable = true;
  };

  environment.systemPackages = with pkgs; [
    ourSwaybg
    unstable.miriway
    wofi
    yambar
    grim
    slurp
    xfce.xfce4-appfinder
    xfce.xfce4-terminal
  ];
}
