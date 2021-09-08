{ config, lib, pkgs, meta, ... }:

{
  virtualisation.docker.enable = true;
  users.users.iris.extraGroups = [ "docker" ];
}
