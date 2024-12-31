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

  boot.supportedFilesystems = {
    nfs = lib.mkForce true;
    zfs = lib.mkDefault true;
  };

  time.timeZone = lib.mkForce "Etc/UTC";
}
