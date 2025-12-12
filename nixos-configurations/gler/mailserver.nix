{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.mailserver;
in
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

    loginAccounts = {
      "nukdokplex@nukdokplex.ru" = {
        hashedPasswordFile = config.age.secrets.nukdokplex-mail-hashed-password.path;
        catchAll = [
          "nukdokplex.ru"
          "nukdotcom.ru"
        ];
      };
      "admin@teanin.shop" = {
        hashedPasswordFile = config.age.secrets.admin-teanin-shop-mail-hashed-password.path;
      };
      "noreply@teanin.shop" = {
        hashedPasswordFile = config.age.secrets.noreply-teanin-shop-mail-hashed-password.path;
        sendOnly = true;
      };
    };
    certificateScheme = "acme-nginx";
  };

  networking.nftables.firewall.rules.open-ports-uplink.allowedTCPPorts =
    lib.mkIf (cfg.enable && cfg.openFirewall)
      (
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
    admin-teanin-shop-mail-password = {
      intermediary = true;
      generator = {
        script = "strong-password";
      };
    };
    admin-teanin-shop-mail-hashed-password = {
      generator = {
        dependencies.password = config.age.secrets.admin-teanin-shop-mail-password;
        script = "mkpasswd-bcrypt";
      };
    };
    noreply-teanin-shop-mail-password = {
      intermediary = true;
      generator = {
        script = "strong-password";
      };
    };
    noreply-teanin-shop-mail-hashed-password = {
      generator = {
        dependencies.password = config.age.secrets.noreply-teanin-shop-mail-password;
        script = "mkpasswd-bcrypt";
      };
    };
  };
}
