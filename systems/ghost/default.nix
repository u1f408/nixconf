{ meta
, pkgs
, lib
, ...
}:

{
  imports = [
    meta.nixosModules.prodigi
    meta.nixosModules.workstation-gnome
    meta.nixosModules.loopback-cam
    meta.nixosModules.virt

    ./hw.nix
  ];

  nixpkgs.config.allowUnfree = true;
  services.openssh.openFirewall = lib.mkForce true;
  services.printing.enable = true;

  system.stateVersion = "24.11";
}
