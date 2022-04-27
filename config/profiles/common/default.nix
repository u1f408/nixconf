{ inputs, meta, pkgs, ... }:

{
  imports = with meta; [
    ./home.nix

    users.iris.base
  ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  time.timeZone = "Pacific/Auckland";
}
