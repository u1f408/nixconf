{ machineClass
, pkgs
, lib
, ...
}:

{
  config = lib.mkIf (machineClass != "server") {
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
