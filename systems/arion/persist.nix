{ lib
, pkgs
, ...
}:

# https://grahamc.com/blog/erase-your-darlings/

{
  services.openssh.hostKeys = [
    { path = "/persist/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
    { path = "/persist/etc/ssh/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
  ];

  environment.etc = {
    "NetworkManager/system-connections".source = "/persist/etc/NetworkManager/system-connections/";
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
    "L /var/lib/libvirt - - - - /persist/var/lib/libvirt"
  ];
}
