# this home-manager configuration builds on top of
# homeManagerUsers.iris, because I'm lazy

{ meta
, pkgs
, lib
, ...
}:

{
  imports = [
    meta.homeManagerUsers.iris

    ./git.nix
    ./packages.nix
    ./vscode.nix
  ];

  home.stateVersion = lib.mkForce "24.11";
}
