{ pkgs
, lib
, ...
}:

{
  services.displayManager.sddm.enable = lib.mkForce false;
  services.xserver.displayManager.gdm.enable = true;
}
