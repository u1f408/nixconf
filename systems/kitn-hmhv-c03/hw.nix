{ pkgs
, lib
, ...
}:

{
  u1f408.refind-preboot = {
    enable = true;
    efiSysMountPoint = "/preboot";
    extraInstallCommands = ''
      cp "${pkgs.opencore-drivers}/share/opencore-drivers/X64/NvmExpressDxe.efi" "$out/efi/boot/drivers/"
    '';
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.efiSysMountPoint = "/boot";
    efi.canTouchEfiVariables = lib.mkForce false;
  };

  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" "mitigations=off" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.availableKernelModules = [ "ehci_pci" "isci" "nvme" "usbhid" "usb_storage" "sd_mod" ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/0d25d08e-f547-4ec5-9131-a315a6a8de36";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/0336-213D";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/preboot" = {
      device = "/dev/disk/by-uuid/0399-8836";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkForce true;
  hardware.enableRedistributableFirmware = lib.mkForce true;
}
