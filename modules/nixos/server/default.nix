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

  time.timeZone = lib.mkForce "Etc/UTC";
}
