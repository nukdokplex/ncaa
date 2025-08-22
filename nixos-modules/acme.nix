{
  config,
  pkgs,
  ...
}:
let
  tld = "nukdokplex.ru";
in
{
  security.acme = {
    acceptTerms = true;
    useRoot = true;
    defaults = {
      email = "nukdokplex@gmail.com";
      renewInterval = "daily";
      environmentFile = "${pkgs.writeText "desec-acme-credentials" ''
        DESEC_TOKEN_FILE=${config.age.secrets.desec.path}
      ''}";
      dnsProvider = "desec";
      dnsResolver = "ns1.desec.io:53";
    };

    certs.${config.networking.hostName}.domain = "${config.networking.hostName}.${tld}";
  };

  age.secrets.desec = { };
}
