{ pkgs
, lib
, meta
, ...
}:

{
  u1f408.immutableUsers = {
    enable = true;
    userDescs = ./users.nix;
  };
}
