{ config, pkgs, ... }:

{
  i18n.defaultLocale = "en_NZ.UTF-8";
  time.timeZone = "Pacific/Auckland";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "dvorak";
  };
}
