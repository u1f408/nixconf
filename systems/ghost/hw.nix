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
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelModules = [ "kvm-amd" ];
    blacklistedKernelModules = [ "nouveau" "amdgpu" ];

    extraModulePackages = with config.boot.kernelPackages; [
      nvidia_x11
    ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd = {
    luks.devices."cryptlvm" = {
      preLVM = true;
      device = "/dev/disk/by-uuid/a7f73760-b448-45b9-93af-988eba2cb5b2";
    };

    kernelModules = [ "nvidia" "dm-snapshot" ];
    availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c548977c-31ba-4b0e-8212-0c7c8e7d92f8";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/2D52-7284";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  zramSwap.enable = true;

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    modesetting.enable = true;
    forceFullCompositionPipeline = true;
  };

  hardware.enableRedistributableFirmware = lib.mkForce true;
  hardware.cpu.amd.updateMicrocode = lib.mkForce true;
}
