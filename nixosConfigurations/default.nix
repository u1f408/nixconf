{ inputs
, self
, ...
}:

let
  mkNixOS = hostName: system: { extraSpecialArgs ? {} }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = extraSpecialArgs // {
        inherit inputs;
        meta = self;
        _passthru = {
          inherit hostName system;
        };
      };

      modules = [
        ({ inputs, _passthru, ... }: {
          nixpkgs.hostPlatform = _passthru.system;
          networking.hostName = _passthru.hostName;
        })

        self.nixosModules.base
        ./${hostName}
      ];
    };

in
{
  flake.nixosConfigurations = {
    irisdesk = mkNixOS "irisdesk" "x86_64-linux" {};
  };
}
