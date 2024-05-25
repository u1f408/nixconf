{ meta
, pkgs
, lib
, ...
}:

{
  imports = [
    meta.nixosModules.xfce
    ./hw.nix
  ];

  services.mbpfan.enable = true;
  services.xserver.videoDrivers = lib.mkForce [ "intel" ];

  networking.hostId = "a77c39f7";
  system.stateVersion = "23.11";
}
