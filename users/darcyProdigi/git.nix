{ pkgs
, lib
, ...
}:

{
  programs.git.extraConfig = {
    user = {
      name = lib.mkForce "Darcy Iris";
      email = lib.mkForce "darcy@prodigi.nz";
    };
  };
}
