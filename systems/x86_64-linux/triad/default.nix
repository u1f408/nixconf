{ pkgs
, lib
, inputs
, system
, ...
}:

{
  imports = [
    inputs.wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    nativeSystemd = true;
    defaultUser = "iris";
  };

  iris = {
    enabledUsers = [ "iris" ];
    defaultSystemPackages = true;
    gui = {
      enable = true;
      environment = lib.mkForce "none";
    };
  };

  time.timeZone = "Pacific/Auckland";
  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "23.05";
}
