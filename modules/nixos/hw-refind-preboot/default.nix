{ config
, pkgs
, lib
, ...
}:

with lib;

let
  cfg = config.u1f408.refind-preboot;
  configText = pkgs.writeText "refind-preboot.conf" ''
    timeout 2
    hideui banner
    hideui hints

    # extraRefindConfig follows
    ${cfg.extraRefindConfig}
  '';

  installScript = pkgs.writeScript "refind-preboot-install.sh" ''
    #! ${pkgs.runtimeShell}
    set -e
    export PATH=${makeBinPath (with pkgs; [ coreutils ])}

    out="$1"; shift
    mkdir -p $out/efi/boot/drivers/
    cp ${cfg.refindPackage}/share/refind/refind_x64.efi $out/efi/boot/bootx64.efi
    cp ${configText} $out/efi/boot/refind.conf
    ${cfg.extraInstallCommands}
  '';

in
{
  options.u1f408.refind-preboot = {
    enable = mkEnableOption "rEFInd pre-boot loader" // { default = false; };

    efiSysMountPoint = mkOption {
      type = types.str;
      default = "/preboot";
      description = ''
        Path to ESP for rEFInd pre-boot loader
      '';
    };

    extraInstallCommands = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional shell commands to run after installing rEFInd,
        for copying additional EFI drivers, etc.
      '';
    };

    refindPackage = mkOption {
      type = types.package;
      default = pkgs.refind;
      defaultText = literalExpression "pkgs.refind";
      description = ''
        rEFInd package to use
      '';
    };

    extraRefindConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional configuration to add to refind.conf
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      boot.loader.systemd-boot.extraInstallCommands = ''
        ${installScript} ${cfg.efiSysMountPoint}
      '';

      boot.loader.grub.extraInstallCommands = ''
        ${installScript} ${cfg.efiSysMountPoint}
      '';
    })
  ];
}
