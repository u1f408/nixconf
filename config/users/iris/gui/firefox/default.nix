{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;

    profiles = {
      home-manager-default = {
        id = 0;
        isDefault = true;

        settings = {
          "browser.startup.homepage" = "about:blank";
          "browser.search.region" = "NZ";
          "general.useragent.locale" = "en-NZ";
          "browser.bookmarks.showMobileBookmarks" = true;
          "browser.newtabpage.enabled" = false;
	  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "signon.rememberSignons" = false;
        };

	userChrome = import ./userChrome.css.nix { profile = "home-manager-default"; };
      };
    };

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      tree-style-tab
      ublock-origin
      https-everywhere
      privacy-badger
      multi-account-containers
      facebook-container
      stylus
      violentmonkey
      foxyproxy-standard
      bitwarden
    ];
  };
}
