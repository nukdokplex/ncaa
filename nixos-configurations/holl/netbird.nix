{ config, ... }:
{
  services.netbird.server.custom = {
    enable = true;

    domain = "netbird.nukdokplex.ru";

    clientID = "netbird-client";
    backendID = "netbird-backend";

    keycloakDomain = "keycloak.nukdokplex.ru";
    keycloakRealmName = "netbird";

    coturnPasswordPath = config.age.secrets.netbird-coturn-password.path;
    coturnSalt = config.age.secrets.netbird-coturn-salt.path;
    dataStoreEncryptionKeyPath = config.age.secrets.netbird-datastore-encryption-key.path;
    clientSecretPath = config.age.secrets.netbird-backend-client-secret.path;
  };

  security.acme.certs.netbird.domain = config.services.netbird.server.custom.domain;

  services.nginx.virtualHosts.${config.services.netbird.server.custom.domain} = {
    addSSL = true;
    sslCertificate = "${config.security.acme.certs.netbird.directory}/cert.pem";
    sslCertificateKey = "${config.security.acme.certs.netbird.directory}/key.pem";
  };

  age.secrets = {
    netbird-coturn-password = {
      generator.script = "strong-password";
      owner = "turnserver";
      group = "turnserver";
    };
    netbird-coturn-salt.generator.script = "strong-password";
    netbird-datastore-encryption-key.generator.script = "netbird-datastore-encryption-key";
    netbird-backend-client-secret = { };
  };
}
