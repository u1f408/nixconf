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
  };
}
