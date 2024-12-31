{ lib
, meta
, ...
}:

{
  imports = [
    meta.nixosModules.workstation
  ];

  services.tlp.enable = true;
  services.thermald.enable = true;
}
