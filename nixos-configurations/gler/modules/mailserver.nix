{ config, lib, flakeRoot, ... }: let
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
  nukdokplexAliases = builtins.filter 
    (alias: !((alias.username == "nukdokplex") && (alias.domain == "nukdokplex.ru")))
    (
      lib.flatten (
        builtins.map
          (domain: builtins.map 
            (username: { inherit domain username; })
            nukdokplexUsernames
          )
          config.mailserver.domains
      )
    );
in {
  mailserver = {
    enable = true;
    fqdn = "${config.networking.hostName}.nukdokplex.ru";
    domains = [
      "nukdokplex.ru"
      "nukdotcom.ru"
    ];

    # email crawler resistance, maybe
    loginAccounts.${builtins.concatStringsSep "@" [ "nukdokplex" "nukdokplex.ru" ]} = {
      hashedPasswordFile = config.age.secrets.nukdokplex-mail-hashed-password.path;
      aliases = builtins.map 
        (alias: builtins.concatStringsSep "@" [ alias.username alias.domain ])
        nukdokplexAliases;
    };
    certificateScheme = "acme-nginx";
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = builtins.concatStringsSep "@" [ "admin" "nukdokplex.ru" ];

  age.secrets.nukdokplex-mail-hashed-password = {
    rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/nukdokplex-mail-hashed-password.age;
    generator.script = "mail-hashed-password";
  };

  age.generators.mail-hashed-password = { pkgs, lib, file, ... }: 
    "'${lib.getExe pkgs.pwgen}' -s 32 1 | '${lib.getExe' pkgs.coreutils "tee"}' ${lib.escapeShellArg (lib.removeSuffix ".age" file)} | '${lib.getExe pkgs.mkpasswd}' -sm bcrypt"; 
}
