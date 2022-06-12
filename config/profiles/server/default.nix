{ inputs, meta, pkgs, lib ? pkgs.lib, ... }:

{
  imports = with meta; [ ];

  time.timeZone = lib.mkForce "Etc/UTC";
  i18n.defaultLocale = lib.mkForce "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = lib.mkForce true;
}
