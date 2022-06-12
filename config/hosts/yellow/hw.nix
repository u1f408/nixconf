{ config, pkgs, lib ? pkgs.lib, ... }:

{
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "rpool/nixos";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/nix" =
    {
      device = "rpool/nixos/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home" =
    {
      device = "rpool/userdata/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/root" =
    {
      device = "rpool/userdata/home/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home/iris" =
    {
      device = "rpool/userdata/home/iris";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/srv/http" =
    {
      device = "rpool/userdata/srv/http";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/0E24-8E49";
      fsType = "vfat";
      options = [ "X-mount.mkdir" ];
    };

  swapDevices = [ ];
}
