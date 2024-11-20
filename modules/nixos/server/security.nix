{ pkgs
, lib
, ...
}:

{
  services.openssh = {
    enable = true;
    settings = {
      UseDns = false;
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  security.sudo = {
    wheelNeedsPassword = lib.mkForce false;
    execWheelOnly = lib.mkForce true;
  };
}