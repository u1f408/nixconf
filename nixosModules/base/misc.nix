{ pkgs
, lib
, ...
}:

{
  services.dbus.implementation = "broker";
  zramSwap.algorithm = "lz4";

  boot.tmp.useTmpfs = lib.mkDefault true;
  boot.tmp.cleanOnBoot = lib.mkDefault true;
}
