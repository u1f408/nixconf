{ machineClass
, pkgs
, lib
, ...
}:

{
  home.packages = (with pkgs; [
    jq
    mle
    fzf
    tmux
  ]) ++ lib.optionals (machineClass != "server") (with pkgs; [
    ptyxis
    remmina
    bitwarden
  ]);
}
