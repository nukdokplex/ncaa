{ config, ... }:
let
  domain = "keycloak.nukdokplex.ru";
in
{
  services.keycloak = {
    enable = true;
    settings = {
      http-enabled = true;
      https-port = 44583;
      http-port = 44582;
      http-host = "::1";
      hostname = "https://${domain}";
      hostname-strict-https = false;
      proxy-headers = "xforwarded";
      # proxy-trusted-addresses = "127.0.0.1,::1";
    };
    sslCertificate = "${config.security.acme.certs.keycloak.directory}/cert.pem";
    sslCertificateKey = "${config.security.acme.certs.keycloak.directory}/key.pem";
    initialAdminPassword = "penismusic";
    database = {
      createLocally = true;
      type = "postgresql";
      port = config.services.postgresql.settings.port;
      passwordFile = config.age.secrets.keycloak-database-password.path;
    };
  };

  security.acme.certs.keycloak = { inherit domain; };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    sslCertificate = "${config.security.acme.certs.keycloak.directory}/cert.pem";
    sslCertificateKey = "${config.security.acme.certs.keycloak.directory}/key.pem";
    locations."/".proxyPass = "http://[::1]:${toString config.services.keycloak.settings.http-port}";
  };

  users.users.keycloak.extraGroups = [ "acme" ]; # allow keycloak access certs

  age.secrets.keycloak-database-password = {
    generator.script = "strong-password";
    owner = "keycloak";
    group = "keycloak";
    mode = "400";
  };

  users.users.keycloak = {
    isSystemUser = true;
    group = "keycloak";
  };

  users.groups.keycloak = { };
}
