{ _passthru
, inputs
, pkgs
, lib
, ...
}:

{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = [
    inputs.agenix.packages."${_passthru.system}".default
  ];

  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" "/persist/etc/ssh/ssh_host_ed25519_key" ];
  };
}
