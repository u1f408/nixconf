{ pkgs
, lib
, ...
}:

{
  home.packages = with pkgs; [
    u1f408-x
    python3
    keychain
    jq
    git
    bat
    mle
    tmux
  ];

  home.stateVersion = "23.11";
}
