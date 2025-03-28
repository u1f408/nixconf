{ lib
, ...
}:

{
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  boot.kernelModules = [ "kvm_intel" ];
  boot.initrd = {
    availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_blk" ];
    kernelModules = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/vda1";
      fsType = "ext4";
    };
  };
}
