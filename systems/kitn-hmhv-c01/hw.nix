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
      device = "/dev/disk/by-uuid/2215a58a-fbe6-40c0-b008-78511363a351";
      fsType = "xfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/10FE-B063";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/preboot" = {
      device = "/dev/disk/by-uuid/1098-618E";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };

  hardware.cpu.intel.updateMicrocode = lib.mkForce true;
  hardware.enableRedistributableFirmware = lib.mkForce true;
}
