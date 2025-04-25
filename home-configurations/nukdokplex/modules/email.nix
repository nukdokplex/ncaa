args@{ pkgs, lib, config, flakeRoot, inputs, ... }: let
  generatePasswordCommand = name:
    if ((builtins.hasAttr "osConfig" args) && (builtins.hasAttr "${name}-password" args.osConfig.age.secrets))
    then "'${lib.getExe pkgs.coreutils "cat"}' ${lib.escapeShellArg args.osConfig.age.secrets."${name}-password".path}"
    else null;
  gpg = {
    signByDefault = true;
    key = "2CA70354EA1707B9";
  };
  realName = "Viktor Titov";
  accounts = [
    (lib.fix (self: {
      primary = true;
      address = with lib; concatStringsSep "@" (reverseList [ "nukdokplex.ru" "nukdokplex" ]);
      userName = self.address;
      passwordCommand = generatePasswordCommand "nukdokplex-ru-has-nukdokplex";
  
      inherit gpg realName;
  
      imap = {
        host = inputs.self.nixosConfigurations.gler.config.mailserver.fqdn; # wow! so cool reuse!
        port = 993;
        tls.enable = true;
      };
  
      smtp = {
        inherit (self.imap) host;
        port = 465;
        tls.enable = true;
      };
  
      thunderbird = {
        enable = true;
        settings = id: {
          "mail.server.server_${id}.authMethod" = 3;
          "mail.smtpserver.smtp_${id}.authMethod" = 3;
        };
      };
    }))
  
    (lib.fix (self: {
      address = with lib; concatStringsSep "@" (reverseList [ "gmail.com" "nukdokplex" ]);
      userName = self.address;
      passwordCommand = generatePasswordCommand "gmail-com-has-nukdokplex";
  
      inherit gpg realName;
      flavor = "gmail.com";
  
      thunderbird = {
        enable = true;
        settings = id: {
          "mail.server.server_${id}.authMethod" = 3;
          "mail.smtpserver.smtp_${id}.authMethod" = 3;
        };
      };
    }))
  
    (lib.fix (self: {
      address = with lib; concatStringsSep "@" (reverseList [ "gmail.com" "vik.titoff2014" ]);
      userName = self.address;
      passwordCommand = generatePasswordCommand "gmail-com-has-vik-titoff2014";
  
      inherit gpg realName;
      flavor = "gmail.com";
  
      thunderbird = {
        enable = true;
        settings = id: {
          "mail.server.server_${id}.authMethod" = 3;
          "mail.smtpserver.smtp_${id}.authMethod" = 3;
        };
  
      };
    }))
  
    (lib.fix (self: {
      address = with lib; concatStringsSep "@" (reverseList [ "outlook.com" "nukdokplex" ]);
      userName = self.address;
      passwordCommand = generatePasswordCommand "outlook-com-has-nukdokplex";
  
      inherit gpg realName;
      flavor = "outlook.office365.com";
  
      thunderbird = {
        enable = true;
        settings = id: {
          "mail.server.server_${id}.authMethod" = 3;
          "mail.smtpserver.smtp_${id}.authMethod" = 3;
        };
      };
    }))
  
    (lib.fix (self: {
      address = with lib; concatStringsSep "@" (reverseList [ "yandex.ru" "vik.titoff2014" ]);
      userName = self.address;
      passwordCommand = generatePasswordCommand "yandex-ru-has-vik-titoff2014";
  
      inherit gpg realName;
      flavor = "yandex.com";
  
      thunderbird = {
        enable = true;
        settings = id: {
          "mail.server.server_${id}.authMethod" = 3;
          "mail.smtpserver.smtp_${id}.authMethod" = 3;
        };
      };
    }))
  ];
in {
  programs.thunderbird = {
    enable = lib.mkDefault config.home.isDesktop;
    package = pkgs.thunderbird;
    profiles.default = { 
      isDefault = true;
      accountsOrder = builtins.map
        (a: a.address)
        accounts;
    };
  };

  accounts.email.accounts = lib.listToAttrs (
    builtins.map
      (e: lib.nameValuePair e.address e)
      accounts
  );
}

