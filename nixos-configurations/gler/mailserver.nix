{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.simple-nixos-mailserver.nixosModules.default ];
  mailserver = {
    enable = true;
    stateVersion = 3;
    openFirewall = true;
    fqdn = "${config.networking.hostName}.nukdokplex.ru";
    domains = [
      "nukdokplex.ru"
      "nukdotcom.ru"
      "teanin.shop"
    ];

    loginAccounts."noreply@teanin.shop" = {
      name = "noreply@teanin.shop";
      sendOnly = true;
      hashedPasswordFile = config.age.secrets.noreply-teanin-mail-hashed-password.path;
    };

    # email crawler resistance, maybe
    loginAccounts.${
      builtins.concatStringsSep "@" [
        "nukdokplex"
        "nukdokplex.ru"
      ]
    } =
      {
        hashedPasswordFile = config.age.secrets.nukdokplex-mail-hashed-password.path;
        catchAll = [
          "nukdokplex.ru"
          "nukdotcom.ru"
        ];
      };
    certificateScheme = "manual";
    certificateFile = "${
      config.security.acme.certs.${config.networking.hostName}.directory
    }/fullchain.pem";
    keyFile = "${config.security.acme.certs.${config.networking.hostName}.directory}/key.pem";
  };

  # this services must be reloaded after cert renewal
  security.acme.certs.${config.networking.hostName}.reloadServices = [
    "postfix.service"
    "dovecot2.service"
  ];

  networking.nftables.firewall.rules.open-ports-uplink.allowedTCPPorts =
    let
      cfg = config.mailserver;
    in
    lib.mkIf (cfg.enable && cfg.openFirewall) (
      [ 25 ]
      ++ lib.optional cfg.enableSubmission 587
      ++ lib.optional cfg.enableSubmissionSsl 465
      ++ lib.optional cfg.enableImap 143
      ++ lib.optional cfg.enableImapSsl 993
      ++ lib.optional cfg.enablePop3 110
      ++ lib.optional cfg.enablePop3Ssl 995
      ++ lib.optional cfg.enableManageSieve 4190
      ++ lib.optional (cfg.certificateScheme == "acme-nginx") 80
    );

  age.secrets = {
    nukdokplex-mail-hashed-password = { };
    noreply-teanin-mail-password.generator.script = "strong-password";
    noreply-teanin-mail-hashed-password.generator = {
      dependencies.password = config.age.secrets.noreply-teanin-mail-password;
      script = "mkpasswd-bcrypt";
    };
  };
}
