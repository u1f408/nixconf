{ pkgs, ... }:

{
  imports = [
    ./theme.nix
    ./packages.nix
    ./shell.nix
    ./bat.nix
    ./neovim
    ./tmux.nix
  ];

  home.sessionVariables = {
    "WINIT_HIDPI_FACTOR" = "1";
    "EDITOR" = "${pkgs.neovim}/bin/neovim";
  };
}
