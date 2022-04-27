{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.sublime4
    unstable.sublime-merge
  ];
}
