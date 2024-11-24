{ meta
, lib
, ...
}:

{
  imports = [
    meta.nixosModules.users
    meta.nixosModules.refind-preboot

    ./nix.nix
    ./packages.nix
    ./networking.nix
    ./home-manager.nix
  ];

  time.timeZone = lib.mkDefault "Etc/UTC";
  boot.tmp.useTmpfs = lib.mkDefault true;
  boot.tmp.cleanOnBoot = lib.mkDefault true;

  services.dbus.implementation = "broker";
  zramSwap.algorithm = "lz4";
}
