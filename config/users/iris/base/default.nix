{ pkgs, ... }:

{
  imports = [
    ./neovim.nix
    ./git.nix
    ./shell.nix
    ./bat.nix
    ./tmux.nix
  ];

  home.sessionVariables = {
    "WINIT_HIDPI_FACTOR" = "1";
    "EDITOR" = "${pkgs.neovim}/bin/neovim";
  };
}
