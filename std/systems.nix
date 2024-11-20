{ inputs
, self
, ...
}:

with builtins;
with inputs.nixpkgs.lib;

{
  mkNixOS = hostName: system: { extraSpecialArgs ? {} }:
    let
      res = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = extraSpecialArgs // {
          inherit inputs;
          meta = self;
          _passthru = {
            inherit hostName system;
          };
        };

        modules = [
          ({ inputs, _passthru,... }: {
            nixpkgs.hostPlatform = _passthru.system;
            networking.hostName = _passthru.hostName;
          })

          self.nixosModules.base
          "${self}/systems/${hostName}"
        ];
      };

    in { "${hostName}" = res; };
}
