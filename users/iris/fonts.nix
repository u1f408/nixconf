{ systemConfig
, pkgs
, lib
, ...
}:

let
  inherit (systemConfig.u1f408) machineClass machineUsage;
  shouldUse = with lib; any (f: hasPrefix "gui-" f) machineUsage;
in
{
  config = lib.mkIf shouldUse {
    fonts.fontconfig = {
      enable = true;
      defaultFonts.emoji = [ "OpenMoji Color" ];
    };

    home.packages = with pkgs; [
      nerd-fonts."m+"
      nerd-fonts.shure-tech-mono
      nerd-fonts.comic-shanns-mono
      comic-mono
      openmoji-black
      openmoji-color
    ];
  };
}
