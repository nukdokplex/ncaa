{
  config,
  lib,
  flakeRoot,
  ...
}:
let
  nukdokplexUsernames = [
    "nukdokplex"
    "temporal"
    "vk1"
    "vk2"
    "vk3"
    "admin"
    "master"
    "postmaster"
    "webmaster"
    "hostmaster"
    "grandmaster"
  ];
  nukdokplexAliases =
    builtins.filter (alias: !((alias.username == "nukdokplex") && (alias.domain == "nukdokplex.ru")))
      (
        lib.flatten (
          builtins.map (
            domain: builtins.map (username: { inherit domain username; }) nukdokplexUsernames
          ) config.mailserver.domains
        )
      );
in
{

  mailserver = {
    enable = true;
    stateVersion = 2;
    fqdn = "${config.networking.hostName}.nukdokplex.ru";
    domains = [
      "nukdokplex.ru"
      "nukdotcom.ru"
    ];

    # email crawler resistance, maybe
    loginAccounts.${
      builtins.concatStringsSep "@" [
        "nukdokplex"
        "nukdokplex.ru"
      ]
    } = {
      hashedPasswordFile = config.age.secrets.nukdokplex-mail-hashed-password.path;
      aliases = builtins.map (
        alias:
        builtins.concatStringsSep "@" [
          alias.username
          alias.domain
        ]
      ) nukdokplexAliases;
    };
    certificateScheme = "manual";
    certificateFile = "${
      config.security.acme.certs.${config.networking.hostName}.directory
    }/fullchain.pem";
    keyFile = "${config.security.acme.certs.${config.networking.hostName}.directory}/key.pem";

  };

  networking.nftables.tables.filter.content =
    let
      cfg = config.mailserver;
      portsToOpen =
        [ 25 ]
        ++ lib.optional cfg.enableSubmission 587
        ++ lib.optional cfg.enableSubmissionSsl 465
        ++ lib.optional cfg.enableImap 143
        ++ lib.optional cfg.enableImapSsl 993
        ++ lib.optional cfg.enablePop3 110
        ++ lib.optional cfg.enablePop3Ssl 995
        ++ lib.optional cfg.enableManageSieve 4190
        ++ lib.optional (cfg.certificateScheme == "acme-nginx") 80;

      portsToOpenString = lib.concatStringsSep ", " (map (port: toString port) portsToOpen);
    in
    lib.mkIf (cfg.enable && cfg.openFirewall) ''
      chain post_input_hook {
        tcp dport { ${portsToOpenString} } counter accept
      }
    '';

  # this services must be reloaded after cert renewal
  security.acme.certs.${config.networking.hostName}.reloadServices = [
    "postfix.service"
    "dovecot2.service"
  ];

  age.secrets.nukdokplex-mail-hashed-password = { };
}
