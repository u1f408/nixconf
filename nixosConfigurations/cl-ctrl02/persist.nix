{ pkgs
, lib
, ...
}:

{
  boot.initrd.postDeviceCommands = ''
    zfs rollback -r z_01ce43/local/root@blank
  '';

  services.openssh.hostKeys = [
    { path = "/persist/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
    { path = "/persist/etc/ssh/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
  ];

  systemd.tmpfiles.rules = [
    "L /var/lib/tailscale - - - - /persist/var/lib/tailscale"
    "L /var/lib/nomad - - - - /persist/var/lib/nomad"
    "L /var/lib/consul - - - - /persist/var/lib/consul"
    "L /var/lib/vault - - - - /persist/var/lib/vault"
  ];
}

