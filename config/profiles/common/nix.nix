{ config, lib, pkgs, sources, ... }:

{
  boot.loader.grub.configurationLimit = 8;
  boot.loader.systemd-boot.configurationLimit = 8;

  nixpkgs.config.allowUnfree = true;

  nix = {
    nixPath = [
      "nixpkgs=${sources.nixpkgs}"
      "NUR=${sources.NUR}"
      "arc=${sources.arc-nixexprs}"
    ];

    extraOptions = "keep-outputs = true";

    gc.automatic = lib.mkDefault true;
    gc.options = lib.mkDefault "--delete-older-than 2w";
    trustedUsers = [ "root" "@wheel" ];

    sandboxPaths = [
      # Workaround for NixOS/nix#5089
      "/var/run/nscd/socket"
    ];
  };
}
