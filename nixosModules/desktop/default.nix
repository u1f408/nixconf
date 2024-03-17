{ inputs
, meta
, pkgs
, lib
, ...
}:

{
  imports = [
    meta.nixosModules.users

    ./networking.nix
    ./lightdm.nix
    ./miriway.nix
  ];

  time.timeZone = lib.mkDefault "Pacific/Auckland";
  environment.systemPackages = with pkgs; [
    remmina
  ];
}
