{ pkgs
, lib
, ...
}:

{
  services.redis = {
    vmOverCommit = true;
    servers."" = {
      enable = true;
      databases = 64;
    };
  };
}
