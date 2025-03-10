{ pkgs
, lib
, ...
}:

{
  imports = [
    ./packages.nix
    ./networking.nix
    ./security.nix
    ./metrics.nix
  ];

  u1f408.machineClass = lib.mkDefault "server";

  boot.supportedFilesystems = {
    nfs = lib.mkForce true;
    zfs = lib.mkDefault true;
  };

  time.timeZone = lib.mkForce "Etc/UTC";
}
