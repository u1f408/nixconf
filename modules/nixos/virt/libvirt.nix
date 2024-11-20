{ pkgs
, lib
, ...
}:

{
  u1f408.immutableUsers.extraAdminGroups = [ "libvirtd" "kvm" ];

  virtualisation.libvirtd = {
    enable = true;
    nss.enableGuest = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      ovmf.enable = true;
      swtpm.enable = true;
    };
  };
}