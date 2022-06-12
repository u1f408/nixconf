{ pkgs, lib, ... }:

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
    extraGroups = [ "wheel" "video" "systemd-journal" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1z1i58CQbOsDdr79JgEzkwl0nqartlGcI9DSJAYWSF iris@maus"
    ];
  };
}
