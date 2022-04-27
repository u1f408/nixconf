{ pkgs, ... }:

{
  imports = [
    ./neovim.nix
    ./git.nix
  ];

  home.sessionVariables = {
    "WINIT_HIDPI_FACTOR" = "1";
    "EDITOR" = "${pkgs.neovim}/bin/neovim";
  };
}
