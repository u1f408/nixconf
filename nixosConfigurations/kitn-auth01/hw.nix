{ pkgs
, lib
, ...
}:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.kernelModules = [ ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_scsi" "usbhid" "sr_mod" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/90f1ed8b-69bf-4d21-84ec-89c5c15d2b81";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/D8FB-BAEC";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
