{ sources, ... }:

{
  imports = [
    (import (sources.home-manager + "/nixos"))
    (import (sources.arc-nixexprs + "/modules")).nixos
    # (import (sources.kat-nixexprs + "/modules")).nixos
    (import (sources.papa-nixexprs + "/modules")).nixos
    (import (sources.nixexprs + "/modules")).nixos
  ];
}
