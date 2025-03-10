{ meta
, pkgs
, lib
, ...
}:

{
  imports = [
    meta.nixosModules.workstation
    ./displayManager.nix
    ./packages.nix
  ];

  services.xserver.desktopManager.gnome.enable = true;
}
