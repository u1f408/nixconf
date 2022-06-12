{ inputs, meta, config, pkgs, lib ? pkgs.lib, ... }:

{
  services.phpfpm =
    let
      myphp = (pkgs.php80.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          yaml
          imagick
        ]));
      });

    in
    {
      phpPackage = myphp;
      pools.www = {
        user = config.services.nginx.user;
        settings = {
          "listen.owner" = config.services.nginx.user;

          pm = "dynamic";
          "pm.max_children" = 8;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 1;
          "pm.max_spare_servers" = 4;
          "pm.max_requests" = 500;
        };
      };
    };
}
