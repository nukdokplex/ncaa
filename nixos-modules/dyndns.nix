{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  obfuscatedMail = "moc_liamg[has]nukdokplex";
  deobfuscatedMail = inputs.self.lib.deobfuscateMail obfuscatedMail;
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

    usev4 = "cmdv4, cmdv4=\"'${lib.getExe pkgs.curl}' https://checkipv4.dedyn.io/\"";
    usev6 = "cmdv6, cmdv6=\"'${lib.getExe pkgs.curl}' https://checkipv6.dedyn.io/\"";

    username = tld;
    passwordFile = config.age.secrets.desec.path;
    domains = [ "${config.networking.hostName}.${tld}" ];
  };

  security.acme = {
    acceptTerms = true;
    useRoot = true;
    defaults = {
      email = deobfuscatedMail;
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
