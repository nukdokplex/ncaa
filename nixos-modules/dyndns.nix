{
  config,
  lib,
  lib',
  pkgs,
  inputs,
  ...
}:
let
  tld = "nukdokplex.ru";
in
{
  age.secrets.desec = { };

  services.ddclient = {
    enable = true;
    interval = "10min";
    protocol = "dyndns2";
    ssl = true;
    server = "update.dedyn.io"; # deSEC

    usev4 = lib.mkDefault "cmdv4, cmdv4=\"'${lib.getExe pkgs.curl}' https://checkipv4.dedyn.io/\"";
    # usev6 = "cmdv6, cmdv6=\"'${lib.getExe pkgs.curl}' https://checkipv6.dedyn.io/\"";
    usev6 = lib.mkDefault "cmdv6, cmdv6=\"'${
      lib.getExe inputs.self.packages.${pkgs.system}.getv6addresses
    }' -p -e -x | tr '\\n' ',' | sed 's/,*$//'\"";

    username = tld;
    passwordFile = config.age.secrets.desec.path;
    domains = [ "${config.networking.hostName}.${tld}" ];
  };

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

    certs.${config.networking.hostName} = lib.fix (cert: {
      domain = "${config.networking.hostName}.${tld}";
      # extraDomainNames = [ "*.${cert.domain}" ];
      dnsProvider = "desec";
      dnsResolver = "ns1.desec.io:53";
    });
  };
}
