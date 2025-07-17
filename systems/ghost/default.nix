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

  u1f408 = {
    machineClass = "desktop";
    machineUsage = [ "gui-local" "av" ];
  };

  nixpkgs.config.allowUnfree = true;
  services.openssh.openFirewall = lib.mkForce true;
  services.printing.enable = true;

  system.stateVersion = "24.11";
}
