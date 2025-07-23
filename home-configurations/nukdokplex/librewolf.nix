{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.home.isDesktop {
    programs.librewolf = {
      enable = lib.mkDefault config.home.isDesktop;

      nativeMessagingHosts = with pkgs; [
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

        DNSOverHTTPS.Enabled = false;

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
            extensions = [
              {
                id = "addon@darkreader.org";
                default_area = "navbar";
                private_browsing = false;
              } # Dark Reader
              {
                id = "uBlock0@raymondhill.net";
                default_area = "navbar";
                private_browsing = true;
              } # uBlock Origin
              {
                id = "jid1-KKzOGWgsW3Ao4Q@jetpack";
                default_area = "navbar";
                private_browsing = false;
              } # I don't care about cookies
              {
                id = "jid1-MnnxcxisBPnSXQ@jetpack";
                default_area = "navbar";
                private_browsing = true;
              } # Privacy badger
              {
                id = "sponsorBlocker@ajay.app";
                default_area = "navbar";
                private_browsing = false;
              } # SponsorBlock for YouTube
              {
                id = "{762f9885-5a13-4abd-9c77-433dcd38b8fd}";
                default_area = "navbar";
                private_browsing = false;
              } # Return YouTube Dislike
              {
                id = "keepassxc-browser@keepassxc.org";
                default_area = "navbar";
                private_browsing = true;
              } # KeePassXC-Browser
              {
                id = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
                default_area = "navbar";
                private_browsing = true;
              } # vimium
            ];
            makeExtensionParams =
              { id, ... }@args:
              {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
                installation_mode = "normal_installed";
              }
              // args;
          in
          (builtins.listToAttrs (
            builtins.map (
              { id, ... }@args: (lib.nameValuePair id (makeExtensionParams ({ inherit id; } // args)))
            ) extensions
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

        SearchEngines = {
          Add = {
            Google = {
              Name = "Google";
              URLTemplate = "https://www.google.com/search?hl=ru&q={searchTerms}";
              SuggestURLTemplate = "https://www.google.com/complete/search?client=firefox&q={searchTerms}&hl=ru";
              IconURL = "https://www.google.com/favicon.ico";
              Alias = "g";
              Description = "Google Search";
            };
          };
          Default = "Google";
        };

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
        };
      };
    };
    stylix.targets.librewolf.profileNames = [ "default" ];
  };
}
