{ pkgs, ... }:

{
  programs.termite = {
    enable = true;

    sizeHints = true;
    urgentOnBell = true;
    scrollbackLines = 10000;
    browser = "${pkgs.xdg-utils}/xdg-open";

    cursorShape = "block";
    font = "Cascadia Code 10";

    cursorColor = "#516d7b";
    cursorForegroundColor = "#ebf8ff";
    backgroundColor = "#ebf8ff";
    foregroundColor = "#516d7b";
    foregroundBoldColor = "#516d7b";
    colorsExtra = ''
      color0  = #ebf8ff
      color8  = #7195a8
      color7  = #516d7b
      color15 = #161b1d
      color1  = #d22d72
      color9  = #d22d72
      color2  = #568c3b
      color10 = #568c3b
      color3  = #8a8a0f
      color11 = #8a8a0f
      color4  = #257fad
      color12 = #257fad
      color5  = #6b6bb8
      color13 = #6b6bb8
      color6  = #2d8f6f
      color14 = #2d8f6f
      color16 = #935c25
      color17 = #b72dd2
      color18 = #c1e4f6
      color19 = #7ea2b4
      color20 = #5a7b8c
      color21 = #1f292e
    '';
  };
}
