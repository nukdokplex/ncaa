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
    } =
      {
        hashedPasswordFile = config.age.secrets.nukdokplex-mail-hashed-password.path;
        aliases = builtins.map (
          alias:
          builtins.concatStringsSep "@" [
            alias.username
            alias.domain
          ]
        ) nukdokplexAliases;
      };
    certificateScheme = "manual";;
    certificateFile = "${config.security.acme.certs.${config.networking.hostName}.directory}/fullchain.pem";
  };

  # this services must be reloaded after cert renewal
  security.acme.certs.${config.netwokring.hostName}.reloadServices = [
    "postfix.service"
    "dovecot2.service"
  ];

  age.secrets.nukdokplex-mail-hashed-password.generator.script = "mail-hashed-password";
}
