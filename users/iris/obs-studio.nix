{ systemConfig
, pkgs
, lib
, ...
}:

let
  inherit (systemConfig.u1f408) machineClass machineUsage;
  shouldUse = with lib; any (f: f == "av") machineUsage;
in
{
  config = lib.mkIf shouldUse {
    programs.obs-studio = {
      enable = true;
      package = pkgs.obs-studio;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-shaderfilter
        obs-vaapi
        obs-ndi
      ];
    };
  };
}
