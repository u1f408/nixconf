{ config, lib, pkgs, meta, ... }:

{
  imports = with meta; [
    users.iris.base
    ./home.nix
    ./locale.nix
    ./net.nix
    ./ssh.nix
    ./nix.nix
    ./access.nix
    ./packages.nix
  ];
}
