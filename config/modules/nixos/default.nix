{ sources, ... }:

{
  imports = [
    (import (sources.nixexprs + "/modules")).nixos
    (import (sources.arc-nixexprs + "/modules")).nixos
    (sources.tf-nix + "/modules/nixos/secrets.nix")
    (sources.tf-nix + "/modules/nixos/secrets-users.nix")
    ./deploy.nix
    ./secrets.nix
    # (import (sources.kat-nixexprs + "/modules")).nixos
  ];
}
