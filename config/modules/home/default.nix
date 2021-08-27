{ sources, ... }:

{
  imports = [
    (import (sources.nixexprs + "/modules")).home
    (import (sources.arc-nixexprs + "/modules")).home-manager
    # (import (sources.kat-nixexprs + "/modules")).home
    (sources.tf-nix + "/modules/home/secrets.nix")
    ./deploy.nix
   ];
}
