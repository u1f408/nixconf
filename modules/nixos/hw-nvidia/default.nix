{ pkgs
, lib
, config
, ...
}:

with lib;
with builtins;

let
  machineClass = config.u1f408.machineClass;
  nvPackage = config.hardware.nvidia.package;

in
{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];

  boot = {
    blacklistedKernelModules = [ "nouveau" "amdgpu" ];
    initrd.kernelModules = [ "nvidia" ]
      ;
    extraModulePackages = [ nvPackage ]
      ;
  };

  environment.systemPackages = with pkgs; [
    cudatoolkit
  ];

  systemd.services.nvidia-control-devices = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${nvPackage.bin}/bin/nvidia-smi";
  };

  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];

    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  nixpkgs.config.nvidia.acceptLicense = true;
}
