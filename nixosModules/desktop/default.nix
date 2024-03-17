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
  security.sudo.wheelNeedsPassword = false;
  environment.systemPackages = with pkgs; [
    remmina
  ];
}
