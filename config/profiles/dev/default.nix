{ config, lib, pkgs, meta, ... }:

{
  imports = [
    ./earmms-keyderiv.nix
    ./docker.nix
    ./libvirt.nix
  ];

  services.postgresql.enable = true;
  services.redis.enable = true;
}
