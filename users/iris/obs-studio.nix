{ machineClass
, pkgs
, lib
, ...
}:

{
  config = lib.mkIf (machineClass != "server") {
    programs.obs-studio = {
      enable = true;
      package = pkgs.obs-studio;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-shaderfilter
        obs-nvfbc
      ];
    };
  };
}