{ pkgs
, lib
, ...
}:

{
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    apple-cursor
  ];
}
