{ inputs
, pkgs
, ...
}:

{
  imports = [
    ./networking.nix
    ./security.nix
  ];

  time.timeZone = "Etc/UTC";
}
