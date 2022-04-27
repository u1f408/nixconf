rec {
  base = ./base.nix;
  gui = ./gui.nix;

  guiFull = { ... }:
    {
      imports = [
        ./gui.nix
      ];
    };
}
