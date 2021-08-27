{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
 
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.kernelModules = [ "nvme" ];
  
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };
  
  fileSystems."/data" = {
    device = "/dev/sda";
    fsType = "xfs";
  };
}
