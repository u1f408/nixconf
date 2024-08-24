{ config
, lib
, pkgs
, ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  boot.kernelModules = [ "kvm-intel" "i915" ];
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];

  boot.initrd.luks.devices."cryptzfs".device = "/dev/disk/by-uuid/b8febdc1-6325-4dcd-a9ee-f7b511648e61";
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r z_801a99/local/root@blank
  '';

  fileSystems = {
    "/" = { device = "z_801a99/local/root"; fsType = "zfs"; };
    "/nix" = { device = "z_801a99/local/nix"; fsType = "zfs"; };
    "/home" = { device = "z_801a99/safe/home"; fsType = "zfs"; };
    "/root" = { device = "z_801a99/safe/home/root"; fsType = "zfs"; };
    "/persist" = { device = "z_801a99/safe/persist"; fsType = "zfs"; };

    "/boot" = {
      device = "/dev/disk/by-uuid/6AA0-D98B";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  zramSwap.enable = true;

  hardware.enableRedistributableFirmware = lib.mkForce true;
  hardware.cpu.intel.updateMicrocode = lib.mkForce true;
}
