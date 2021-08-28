{ root, config, pkgs, lib, ... }:

{
  home-manager.users.iris = {
    imports = [
      ./base
    ];
    home.stateVersion = "21.05";
  };

  users.users.iris = {
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "systemd-journal" "machine-cert" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3upW9y/876/22VyiAmLHd+WOx1WXzqWPPxRdNJm2P3 iris@ruby"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFwllqJdw4RvcR4b0G9UqPJwRCSX7Mm5I5ImpiR+OUu iris@luka"
    ];
  };
}
