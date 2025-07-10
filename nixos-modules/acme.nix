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
    };

    certs.${config.networking.hostName} = {
      domain = "${config.networking.hostName}.${tld}";
      # extraDomainNames = [ "*.${cert.domain}" ];
      dnsProvider = "desec";
      dnsResolver = "ns1.desec.io:53";
    };
  };

  age.secrets.desec = { };
}
