{ config, lib, pkgs, meta, ... }:

{
  services.earmms-keyderiv = {
    enable = true;
    listenPort = 23198;
    targets.local = {
      sharedSecret = "420985d9afb8c662e1dfcaea47ae0279b8cb7d8e3eb64157bc26b8449615cf8b";
      indexKey = "d72b16f9c72c0cab79107e703dd9d92ee82090913c8a2d0e0693da496300be42";
      encryptKey = "e4cc32fc801da9a8a44f8de00ec33ce47a8c633baa6872cfc1435d4e1b4944e9";
    };
  };
}
