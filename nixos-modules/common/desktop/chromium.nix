{ lib, config, ... }: {
  config = lib.mkIf config.common.desktop.enable {
    programs.chromium = {
      enable = true;
      extraOpts = {
        # brave specific
        # https://support.brave.com/hc/en-us/articles/360039248271-Group-Policy
        TorDisabled = false;
        BraveRewardsDisabled = true;
        BraveWalletDisabled = true;
        BraveVPNDisabled = 1;
        BraveAIChatEnabled = false;
        # common
        # https://chromeenterprise.google/policies
        SyncDisabled = true;
        PasswordManagerEnabled = false;
        SpellcheckEnabled = true;
        SpellcheckLanguage = [
          "en-US"
          "ru"
        ];
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        ImportAutofillFormData = false;
      };
    };
  };
}
