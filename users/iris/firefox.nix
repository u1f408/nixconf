{ inputs
, pkgs
, lib
, ...
}:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = {
        enableGnomeExtensions = true;
      };
    };

    profiles.irisMain = {
      isDefault = true;
      search.default = "DuckDuckGo";

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        sidebery
      ];

      settings = {
        "general.useragent.locale" = "en-NZ";
        "distribution.searchplugins.defaultLocale" = "en-NZ";
        "browser.startup.homepage" = "about:blank";
        "browser.search.region" = "NZ";
        "browser.search.isUS" = false;

        "layout.css.has-selector.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "devtools.everOpened" = true;
        "devtools.command-button-measure.enabled" = true;
        "devtools.command-button-rulers.enabled" = true;
        "devtools.command-button-screenshot.enabled" = true;
      };

      userChrome = ''
        #TabsToolbar {
          visibility: collapse;
        }

        #sidebar-header:has(#sidebar-title[value="Sidebery"]) {
          visibility: collapse !important;
        }
      '';
    };
  };
}
