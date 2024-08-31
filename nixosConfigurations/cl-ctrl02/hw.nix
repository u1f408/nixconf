{ pkgs
, lib
, ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  boot.kernelParams = [ "iommu=pt" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "ehci_pci" "uas" "usbhid" "sd_mod" ];

  fileSystems = {
    "/" = { device = "z_01ce43/local/root"; fsType = "zfs"; };
    "/nix" = { device = "z_01ce43/local/nix"; fsType = "zfs"; };
    "/home" = { device = "z_01ce43/safe/home"; fsType = "zfs"; };
    "/root" = { device = "z_01ce43/safe/home/root"; fsType = "zfs"; };
    "/persist" = { device = "z_01ce43/safe/persist"; fsType = "zfs"; };

    "/boot" = {
      device = "/dev/disk/by-uuid/4D4C-2C64";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  swapDevices = [ ];
  zramSwap.enable = true;

  hardware.cpu.amd.updateMicrocode = lib.mkForce true;
  hardware.enableRedistributableFirmware = lib.mkForce true;
}
