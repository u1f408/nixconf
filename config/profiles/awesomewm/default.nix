{ config, lib, pkgs, meta, ... }:

{
  imports = [ ];

  services.xserver.windowManager.awesome.enable = true;
}
