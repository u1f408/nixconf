{ pkgs, ... }:

{
  imports = [
    ./termite.nix
    ./fonts.nix
  ];

  home.packages = with pkgs; [
    unstable.sublime4
    unstable.sublime-merge
  ];

  xdg.systemDirs.data = [
    "${pkgs.maia-icon-theme}/share"
    "${pkgs.hicolor-icon-theme}/share"
  ];
}
