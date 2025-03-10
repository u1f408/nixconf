{ lib
, meta
, ...
}:

{
  services.tlp.enable = true;
  services.thermald.enable = true;
}
