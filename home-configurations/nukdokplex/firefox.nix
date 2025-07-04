{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.home.isDesktop {
    programs.firefox = {
      enable = lib.mkDefault config.home.isDesktop;
      package = pkgs.firefox;

      nativeMessagingHosts = with pkgs; [
        tridactyl-native
        keepassxc
      ];

      languagePacks = [
        "ru"
        "en-US"
      ];
      policies = {
        Cookies = {
          Behavior = "reject-tracker";
          BehaviorPrivateBrowsing = "reject-tracker";
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
        ExtensionSettings =
          let
            extensionIds = [
              "addon@darkreader.org" # Dark Reader
              "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" # Stylus
              "twitchinventoryclaimer@schulzjona" # Twitch Inventory Claimer
              "uBlock0@raymondhill.net" # uBlock Origin
              "jid1-KKzOGWgsW3Ao4Q@jetpack" # I don't care about cookies
              "jid1-MnnxcxisBPnSXQ@jetpack" # Privacy badger
              "sponsorBlocker@ajay.app" # SponsorBlock for YouTube
              "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" # Return YouTube Dislike
              "tridactyl.vim@cmcaine.co.uk" # Tridactyl
              "keepassxc-browser@keepassxc.org" # KeePassXC-Browser
            ];
            makeExtensionParams = id: {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
              installation_mode = "normal_installed";
            };
          in
          (builtins.listToAttrs (
            builtins.map (id: (lib.nameValuePair id (makeExtensionParams id))) extensionIds
          ));

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

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
        };
      };
    };
    stylix.targets.firefox.profileNames = [ "default" ];
  };
}
