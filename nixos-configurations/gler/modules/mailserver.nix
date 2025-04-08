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
      builtins.map
        (domain: builtins.map 
          (username: { inherit domain username; })
          nukdokplexUsernames
        )
        config.mailserver.domains
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
    
  };

  age.secrets.nukdokplex-mail-hashed-password.rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/nukdokplex-mail-hashed-password.age;
}
