{ config
, lib
, pkgs
, ...
}:

{
  services.qemuGuest.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd = {
    availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk" ];
    kernelModules = [ ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/5E08-2EEB";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/c30d57fd-7520-4da7-91da-365ee662d354";
      fsType = "xfs";
      neededForBoot = true;
    };

    "/qd" = {
      device = "/dev/disk/by-uuid/2ff45ec7-6e02-4ff6-a750-1f2a7d93df77";
      fsType = "xfs";
    };

    "/nix" = {
      device = "/persist/nix";
      fsType = "none";
      options = [ "bind" ];
    };

    "/var/log" = {
      device = "/persist/var/log";
      fsType = "none";
      options = [ "bind" ];
    };

    "/home" = {
      device = "/persist/home";
      fsType = "none";
      options = [ "bind" ];
    };

    "/root" = {
      device = "/persist/home/root";
      fsType = "none";
      options = [ "bind" ];
    };

    "/etc/nixos" = {
      device = "/persist/etc/nixos";
      fsType = "none";
      options = [ "bind" ];
    };
  };
}
