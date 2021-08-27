{ config, lib, pkgs, meta, ... }:

{
  imports = [ ];

  services.postgresql.enable = true;
  services.redis.enable = true;
}
