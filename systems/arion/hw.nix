{ meta
, config
, lib
, pkgs
, ...
 }:

{
  imports = [
    meta.nixosModules.hw-nvidia
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelParams = [ "nohibernate" "iommu=pt" "module_blacklist=i915" "numa_balancing=off" ];
    kernelModules = [ "kvm-intel" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "uas" "sd_mod" ];

      luks.devices.cryptzfs = {
        preLVM = lib.mkForce true;
        device = "/dev/disk/by-uuid/f940bb46-f104-4782-98e2-685dcd9bf347";
      };

      # postDeviceCommands = ''
      #   zfs rollback -r z_7ad309/local/root@blank
      # '';
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = lib.mkForce false;
  };

  fileSystems = {
    "/" = { device = "z_7ad309/local/root"; fsType = "zfs"; };
    "/nix" = { device = "z_7ad309/local/nix"; fsType = "zfs"; };
    "/persist" = { device = "z_7ad309/safe/persist"; fsType = "zfs"; };
    "/home" = { device = "z_7ad309/safe/home"; fsType = "zfs"; };
    "/root" = { device = "z_7ad309/safe/home/root"; fsType = "zfs"; };

    "/boot" = {
      fsType = "vfat";
      device = "/dev/disk/by-uuid/875E-A28D";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  zramSwap.enable = true;

  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_535;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkForce true;
  hardware.enableRedistributableFirmware = lib.mkForce true;
}
