{ config, lib, pkgs, meta, ... }:

{
  environment.systemPackages = with pkgs; [
    virt-manager
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemuPackage = pkgs.qemu;
  };

  users.users.iris.extraGroups = [ "libvirtd" ];
}

