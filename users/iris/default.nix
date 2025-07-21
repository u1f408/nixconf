{ pkgs
, lib
, ...
}:

{
  imports = [
    ./git.nix
    ./ssh.nix
    ./tmux.nix
    ./shell.nix
    ./fonts.nix
    ./browser.nix
    ./packages.nix
    ./terminal.nix
    ./obs-studio.nix
  ];

  home.sessionVariables = {
    EDITOR = "mle";
  };

  home.stateVersion = lib.mkDefault "23.11";
}
