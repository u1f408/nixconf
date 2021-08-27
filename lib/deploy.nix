{ pkgs
, lib ? pkgs.lib
, hosts
}:

let
  nixosHosts = lib.filterAttrs (name: host: host ? ssh) hosts;

  allGroups = lib.unique
    (lib.flatten (lib.mapAttrsToList (name: host: host.groups) hosts));

  hostsInGroup = group:
    lib.filterAttrs (k: v: builtins.elem group v.groups) hosts;

  hostsInAllGroups = lib.listToAttrs
    (map (group: lib.nameValuePair group (lib.attrNames (hostsInGroup group)))
      allGroups);

  mkDeploy = hostname:
    pkgs.writeScript "deploy-${hostname}" ''
      #!${pkgs.runtimeShell}
      set -xeo pipefail
      export PATH=${with pkgs; lib.makeBinPath [
        coreutils
        openssh
        nix
      ]}

      MODE=$1
      shift || true
      ARGS=$@

      [ "$MODE" == "" ] && MODE="switch"

      ${let
        hostAttrs = nixosHosts.${hostname};
        nixosSystem = hostAttrs.config.system.build.toplevel;
      in ''
        echo "deploying ${hostname}..."
        export NIX_SSHOPTS="$NIX_SSHOPTS -p${toString hostAttrs.ssh.port}"
        nix copy --no-check-sigs --to ssh://${hostAttrs.ssh.host} ${nixosSystem}
        if [ "$MODE" == "switch" ] || [ "$MODE" == "boot" ]; then
          ssh $NIX_SSHOPTS ${hostAttrs.ssh.host} "sudo nix-env -p /nix/var/nix/profiles/system -i ${nixosSystem}"
        fi
        ssh $NIX_SSHOPTS ${hostAttrs.ssh.host} "sudo /nix/var/nix/profiles/system/bin/switch-to-configuration $MODE"
      ''}
    '';

in
{
  deploy = (lib.mapAttrs (hostname: hostAttrs: mkDeploy hostname) nixosHosts);
}

