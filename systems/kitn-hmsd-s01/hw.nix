{ pkgs
, lib
, ...
}:

{
  boot.loader.grub = {
    enable = true;
    device = "/dev/disk/by-id/wwn-0x5002538c4050bea2";
  };

  boot.supportedFilesystems.zfs = true;
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" "mitigations=off" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "mpt3sas" "isci" "usbhid" "usb_storage" "sd_mod" ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c0bdf51f-9871-4a72-bc4a-d1dac411e50d";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9CF5-4BAA";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkForce true;
  hardware.enableRedistributableFirmware = lib.mkForce true;
}
