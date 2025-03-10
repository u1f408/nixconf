{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    jq
    mle
    fzf
    tmux
    ptyxis
    remmina
    bitwarden
  ];
}
