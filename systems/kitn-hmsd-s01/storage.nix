{ pkgs
, lib
, ...
}:

{
  boot.zfs.extraPools = [
    "z_842bd3"
    "z_bd53c8"
  ];

  services.nfs.server = {
    enable = true;
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    extraConfig = ''
      guest ok = yes
      usershare path = /var/lib/samba/usershares
      usershare max shares = 100
      usershare allow guests = yes
      usershare owner only = no
      fruit:copyfile = yes
    '';
  };
}
