{ pkgs
, lib
, ...
}:

{
  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
    settings = {
      UseDns = false;
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  security.sudo = {
    wheelNeedsPassword = lib.mkForce false;
    execWheelOnly = lib.mkDefault true;
  };
}
