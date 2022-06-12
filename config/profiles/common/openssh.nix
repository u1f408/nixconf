{ inputs, meta, pkgs, lib ? pkgs.lib, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 62954 ];
    permitRootLogin = lib.mkForce "prohibit-password";

    passwordAuthentication = false;
    challengeResponseAuthentication = false;

    extraConfig = ''
      AuthenticationMethods publickey
    '';
  };
}
