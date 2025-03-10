{ pkgs
, lib
, ...
}:

{
  services.displayManager = {
    enable = true;
    sddm = {
      enable = lib.mkDefault true;
      wayland.enable = true;
    };
  };
}
