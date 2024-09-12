{ pkgs
, ...
}:

{
  home.packages = with pkgs; [
    u1f408-x

    git
    bat
    mle
    tmux

    jq
    python3
    keychain

    clearlooks-phenix
  ];
}
