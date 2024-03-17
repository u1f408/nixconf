{ inputs
, pkgs
, lib
, ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelModules = [ "kvm-amd" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ohci_pci"
    "ehci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "ahci"
  ];

  fileSystems."/" = {
    device = "/dev/mapper/irisdesk-root";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DC50-E40B";
    fsType = "vfat";
  };

  swapDevices = [ ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
}
