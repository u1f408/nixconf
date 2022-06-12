{ inputs, meta, pkgs, lib ? pkgs.lib, ... }:

{
  imports = with meta; [
    ./home.nix
    ./openssh.nix
    ./tailscale.nix
    ./acme.nix

    users.iris.base
  ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [
    neovim
    tmux
    gitMinimal
    nixpkgs-fmt
  ];

  networking.domain = lib.mkDefault "iris.localdomain";
  time.timeZone = lib.mkDefault "Pacific/Auckland";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = lib.mkDefault false;
}
