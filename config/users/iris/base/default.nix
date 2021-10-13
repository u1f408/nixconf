{ ... }:

{
  imports = [
    ./theme.nix
    ./packages.nix
    ./fonts.nix
    ./shell.nix
    ./bat.nix
    ./neovim
    ./tmux.nix
  ];

  home.sessionVariables = {
    "WINIT_HIDPI_FACTOR" = "1";
  };
}
