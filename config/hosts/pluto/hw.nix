{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/3d2a5747-1a1c-4058-98b6-d05d474069f6";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/59a80876-9fc6-45dc-b0a9-8f33732a212c";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6F5B-6AF6";
    fsType = "vfat";
  };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
