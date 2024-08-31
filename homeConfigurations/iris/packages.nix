{ pkgs
, ...
}:

{
  home.packages = with pkgs; [
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
