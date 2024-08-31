{ inputs
, self
, ...
}:

with builtins;
with inputs.nixpkgs.lib;

let
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
          ({ inputs, _passthru, ... }: {
            nixpkgs.hostPlatform = _passthru.system;
            networking.hostName = _passthru.hostName;
          })

          self.nixosModules.base
          ./${hostName}
        ];
      };

    in { "${hostName}" = res; };

in
{
  flake.nixosConfigurations = mkMerge [
    (mkNixOS "eeby" "x86_64-linux" {})
    (mkNixOS "thonk" "x86_64-linux" {})
    (mkNixOS "iris-dvt-ws01" "x86_64-linux" {})

    # infra VMs
    (mkNixOS "kitn-auth01" "aarch64-linux" {})

    # home cluster
    (mkNixOS "cl-ctrl01" "x86_64-linux" {})
    (mkNixOS "cl-ctrl02" "x86_64-linux" {})
  ];
}
