{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  boot.initrd.kernelModules = [ "nvme" ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6129-FC42";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/sda3";
    fsType = "xfs";
  };
}
