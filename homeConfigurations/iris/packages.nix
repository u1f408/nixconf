{ pkgs
, ...
}:

{
  home.packages = with pkgs; [
    git
    bat
    mle
    tmux
  ];
}
