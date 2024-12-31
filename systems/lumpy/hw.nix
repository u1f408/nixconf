{ pkgs
, lib
, ...
}:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    systemd-boot.enable = true;
    efi.efiSysMountPoint = "/boot";
    efi.canTouchEfiVariables = lib.mkForce false;
  };

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];

  boot.initrd.luks.devices."lumpycrypt" = {
    device = "/dev/disk/by-uuid/93b7ca98-3431-4635-8776-2d1dcda9ec69";
    preLVM = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/lumpy-root";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/5CE1-3681";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkForce true;
  hardware.enableRedistributableFirmware = lib.mkForce true;
}
