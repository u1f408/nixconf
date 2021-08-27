{ ... }:

{
  imports = [
    ./theme.nix
    ./packages.nix
    ./shell.nix
    ./bat.nix
  ];

  home.sessionVariables = {
    "WINIT_HIDPI_FACTOR" = "1";
  };
}
