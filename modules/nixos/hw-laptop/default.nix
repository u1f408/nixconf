{ config
, meta
, lib
, ...
}:

{
  config = lib.mkIf (config.u1f408.machineClass == "laptop") {
    services.thermald.enable = true;
  };
}
