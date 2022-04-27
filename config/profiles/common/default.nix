{ inputs, meta, pkgs, ... }:

{
  imports = with meta; [
    users.iris.base
  ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
