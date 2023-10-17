{ pkgs
, lib
, inputs
, ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.microsoft-surface-go
  ];

  hardware.microsoft-surface.firmware.surface-go-ath10k.replace = true;
  microsoft-surface.surface-control.enable = true;

  boot.kernelParams = [ "mem_sleep_default=deep" ];
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" "sd_mod" "nvme" ];
  boot.initrd.luks = {
    reusePassphrases = true;
    devices.cryptroot.device = "/dev/disk/by-uuid/4a975b7c-8d5e-4592-a014-0988a0152d49";
  };

  fileSystems."/" = {
    device = "/dev/mapper/hydrochaeris-root";
    fsType = "xfs"; 
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/ECC1-C9F4";
    fsType = "vfat";
  };

  swapDevices = [ ];
}
