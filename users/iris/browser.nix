{ systemConfig
, pkgs
, lib
, ...
}:

let
  inherit (systemConfig.u1f408) machineClass machineUsage;
  shouldUse = with lib; any (f: hasPrefix "gui-" f) machineUsage;
in
{
  config = lib.mkIf shouldUse {
    programs.firefox = {
      enable = true;
    };

    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions = [
        # ublock origin
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      ];
    };
  };
}
