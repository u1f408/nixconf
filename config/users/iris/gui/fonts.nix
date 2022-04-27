{ pkgs, ... }:

{
  home.packages = with pkgs; [
    twemoji-color-font
    cascadia-code
    # comic-code
  ];
}
