{ pkgs
, ...
}:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    comic-mono
    comic-neue
    comic-relief
  ];
}
