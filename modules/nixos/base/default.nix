{ inputs
, meta
, lib
, ...
}:

with lib;
with builtins;

let
  cfg = config.u1f408;

in
{
  imports = [
    inputs.agenix.nixosModules.default

    meta.nixosModules.hw-refind-preboot
    meta.nixosModules.hw-laptop

    ./users
    ./nix.nix
    ./packages.nix
    ./networking.nix
    ./home-manager.nix
  ];

  options.u1f408 = {
    machineClass = mkOption {
      type = with types; enum [ "desktop" "laptop" "server" ];
      default = "desktop";
    };
  };

  config = {
    time.timeZone = lib.mkDefault "Etc/UTC";
    boot.tmp.useTmpfs = lib.mkDefault true;
    boot.tmp.cleanOnBoot = lib.mkDefault true;

    services.dbus.implementation = "broker";
    zramSwap.algorithm = "lz4";
  };
}
