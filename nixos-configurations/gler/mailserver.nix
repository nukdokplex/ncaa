{
  config,
  ...
}:
{
  mailserver = {
    enable = true;
    stateVersion = 3;
    openFirewall = true;
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

  age.secrets.nukdokplex-mail-hashed-password = { };
}
