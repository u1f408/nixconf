{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    "BROWSER" = "${pkgs.firefox}/bin/firefox";
  };

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
      bitwarden
      facebook-container
      foxyproxy-standard
      https-everywhere
      multi-account-containers
      privacy-badger
      stylus
      tree-style-tab
      ublock-origin
      violentmonkey
      wayback-machine
      zoom-page-we
      zoom-redirector
    ];
  };
}
