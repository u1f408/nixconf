{ pkgs
, lib
, ...
}:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
  };

  services.redis = {
    # package = pkgs.valkey;
    vmOverCommit = true;
    servers."" = {
      enable = true;
    };
  };
}
