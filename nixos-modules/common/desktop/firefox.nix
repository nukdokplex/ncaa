{ pkgs, lib, config, ... }:
let
  cfg = config.common.desktop;
in
{
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      policies = {
        Cookies = {
          Behavior = "reject-foreign";
          BehaviorPrivateBrowsing = "reject-foreign";
        };

        DisableAppUpdate = true;
        DisableFirefoxStudies = true;
        DisableMasterPasswordCreation = true;
        DisablePocket = true;
        DisableProfileImport = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;

        DisplayBookmarksToolbar = "newtab";

        DNSOverHTTPS = {
          Enabled = false;
        };

        DontCheckDefaultBrowser = true;

        EnableTrackingProtection = {
          Value = true;
          Locked = false;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };

        EncryptedMediaExtensions = {
          Enabled = true;
          Locked = false;
        };

        ExtensionSettings = let
          extensionIds = [
            "batterdarkerdocs@threethan.github.io" # Better Darker Docs
            "addon@darkreader.org" # Dark Reader
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" # Stylus
            "firefox@tampermonkey.net" # Tampermonkey
            "twitchinventoryclaimer@schulzjona" # Twitch Inventory Claimer
            "uBlock0@raymondhill.net" # uBlock Origin
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}" # Vimium
          ];
          makeExtensionParams = id: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
            installation_mode = "normal_installed";
          };
        in builtins.listToAttrs 
          (
            builtins.map
              (id: (lib.nameValuePair id (makeExtensionParams id)))
              extensionIds
          );

        ExtensionUpdate = true;

        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = false;
        };

        FirefoxSuggest = {
          ImproveSuggest = false;
          Locked = false;
          SponsoredSuggestions = false;
          WebSuggestions = false;
        };

        HardwareAcceleration = true;

        Homepage = {
          Locked = false;
          StartPage = "previous-session";
        };

        NewTabPage = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        PasswordManagerEnabled = false;

        PDFjs = {
          Enabled = true;
          EnablePermissions = false;
        };

        Preferences = {
          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.addedImportButton" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "dom.security.https_only_mode" = true;
          "extensions.autoDisableScopes" = 0;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.navigator.mediadatadecoder_vpx_enabled" = true;
          "media.navigator.mediadatadecoder_vp8_hardware_enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
        };

        SearchEngines.Default = "DuckDuckGo";

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
        };

        UseSystemPrintDialog = true;
      };
    };
  };
}
