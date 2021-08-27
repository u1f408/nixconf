{ sources, ... }:

{
  imports = [
    (import (sources.home-manager + "/nixos"))
    (import (sources.nixexprs + "/modules")).nixos
    (import (sources.arc-nixexprs + "/modules")).nixos
    # (import (sources.kat-nixexprs + "/modules")).nixos
  ];
}
