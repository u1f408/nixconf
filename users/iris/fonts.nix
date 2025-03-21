{ pkgs
, ...
}:

{
  fonts.fontconfig = {
    enable = true;
    defaultFonts.emoji = [ "OpenMoji Color" ];
  };

  home.packages = with pkgs; [
    comic-mono
    openmoji-black
    openmoji-color
  ];
}
