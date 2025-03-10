{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    jq
    mle
    tmux
    ptyxis
    remmina
    bitwarden
  ];
}
