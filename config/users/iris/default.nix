rec {
  base = ./base.nix;
  gui = ./gui.nix;
  dev = ./dev.nix;
  hikari = ./hikari.nix;
  awesomewm = ./awesomewm.nix;
  sway = ./sway.nix;

  guiFull = { imports = [ gui dev hikari sway ]; };
}
