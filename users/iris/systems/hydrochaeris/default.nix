{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    krita
    unstable.osu-lazer-bin
  ];
}
