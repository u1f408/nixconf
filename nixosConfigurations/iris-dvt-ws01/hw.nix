{ pkgs
, lib
, ...
}:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  boot.kernelModules = [ ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a6f6fed6-e120-4ef6-99e4-4bd31307468f";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/faaeb342-7636-44cb-af57-a6b2d3e45ff1";
    fsType = "xfs";
  };

  swapDevices = [ ];
}
