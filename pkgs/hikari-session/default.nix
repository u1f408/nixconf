{ hikari, ... }:

hikari.overrideAttrs (oldAttrs: {
  passthru = {
    providedSessions = [ "hikari" ];
  };
})
