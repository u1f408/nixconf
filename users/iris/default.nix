{ pkgs
, lib
, ...
}:

{
  imports = [
    ./git.nix
    ./shell.nix
    ./fonts.nix
    ./browser.nix
    ./packages.nix
    ./vscode.nix
    ./obs-studio.nix
  ];

  home.stateVersion = lib.mkDefault "23.11";
}
