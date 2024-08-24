{ meta
, inputs
, pkgs
, ...
}:

{
  imports = [
    ./networking.nix
    ./security.nix
    ./nginx.nix
  ];

  time.timeZone = "Etc/UTC";

  security.acme = {
    acceptTerms = true;
    defaults.email = "iris@iris.ac.nz";
  };
}
