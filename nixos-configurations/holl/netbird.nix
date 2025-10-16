{ config, lib, ... }:
let
  ssoDomain = "sso.nukdokplex.ru";
  clientId = "339513160329418758";
in
{
  services.netbird.server = {
    enable = true;

    domain = "netbird.nukdokplex.ru";

    signal = {
      enable = true;
      enableNginx = true;
    };

    coturn = {
      enable = true;
      domain = config.services.netbird.server.domain;
      user = "netbird";
      passwordFile = config.age.secrets.netbird-coturn-password.path;
      useAcmeCertificates = true;
    };

    dashboard = {
      enable = true;
      enableNginx = true;
      settings = {
        # Endpoints
        #   NETBIRD_MGMT_API_ENDPOINT="https://netbird.nukdokplex.ru:33073";
        #   NETBIRD_MGMT_GRPC_API_ENDPOINT="https://netbird.nukdokplex.ru:33073";

        # OIDC
        AUTH_AUDIENCE = clientId;
        AUTH_CLIENT_ID = clientId;
        AUTH_CLIENT_SECRET = "";
        AUTH_AUTHORITY = "https://${ssoDomain}";
        USE_AUTH0 = false;
        AUTH_SUPPORTED_SCOPES = "openid profile email offline_access api";
        AUTH_REDIRECT_URI = "/#callback";
        AUTH_SILENT_REDIRECT_URI = "/#silent-callback";
        NETBIRD_TOKEN_SOURCE = "accessToken";

        # SSL
        #   NGINX_SSL_PORT=443

        # Letsencrypt
        #   LETSENCRYPT_DOMAIN=
        #   LETSENCRYPT_EMAIL=
      };
    };

    management = {
      enableNginx = true;
      port = 23461;
      oidcConfigEndpoint = "https://${ssoDomain}/.well-known/openid-configuration";

      settings = {
        DataStoreEncryptionKey._secret = config.age.secrets.netbird-datastore-encryption-key.path;
        DeviceAuthorizationFlow = {
          Provider = "hosted";
          ProviderConfig = {
            Audience = clientId;
            AuthorizationEndpoint = "";
            ClientID = clientId;
            ClientSecret = "";
            DeviceAuthEndpoint = "https://${ssoDomain}/oauth/v2/device_authorization";
            Domain = "";
            RedirectURLs = null;
            Scope = "openid";
            TokenEndpoint = "https://${ssoDomain}/oauth/v2/token";
            UseIDToken = false;
          };
        };
        DisableDefaultPolicy = false;
        HttpConfig = {
          # managed by nixos
          # Address = "0.0.0.0:33073";
          AuthAudience = clientId;
          AuthIssuer = "https://${ssoDomain}";
          AuthKeysLocation = "https://${ssoDomain}/oauth/v2/keys";
          AuthUserIDClaim = "";
          CertFile = "";
          CertKey = "";
          IdpSignKeyRefreshEnabled = true;
          OIDCConfigEndpoint = "https://${ssoDomain}/.well-known/openid-configuration";
        };
        IdpManagerConfig = {
          Auth0ClientCredentials = null;
          AzureClientCredentials = null;
          ClientConfig = {
            ClientID = "netbird";
            ClientSecret._secret = config.age.secrets.netbird-backend-client-secret.path;
            GrantType = "client_credentials";
            Issuer = "https://${ssoDomain}";
            TokenEndpoint = "https://${ssoDomain}/oauth/v2/token";
          };
          ExtraConfig = {
            ManagementEndpoint = "https://${ssoDomain}/management/v1";
          };
          KeycloakClientCredentials = null;
          ManagerType = "zitadel";
          ZitadelClientCredentials = null;
        };
        PKCEAuthorizationFlow = {
          ProviderConfig = {
            Audience = clientId;
            AuthorizationEndpoint = "https://${ssoDomain}/oauth/v2/authorize";
            ClientID = clientId;
            ClientSecret = "";
            DisablePromptLogin = false;
            Domain = "";
            LoginFlag = 0;
            RedirectURLs = [ "http://localhost:53000" ];
            Scope = "openid profile email offline_access api";
            TokenEndpoint = "https://${ssoDomain}/oauth/v2/token";
            UseIDToken = false;
          };
        };
        TURNConfig = {
          Secret._secret = config.age.secrets.netbird-coturn-salt.path;

          Turns = [
            {
              Proto = "udp";
              URI = "turn:${config.services.netbird.server.coturn.domain}:3478";
              Username = config.services.netbird.server.coturn.user;
              Password._secret = config.age.secrets.netbird-coturn-password.path;
            }
          ];
        };
      };
    };
  };

  networking.nftables.firewall.rules.open-ports-uplink = {
    allowedTCPPorts = lib.optionals (
      config.services.netbird.server.enable && config.services.netbird.server.coturn.enable
    ) config.services.netbird.server.coturn.openPorts;
    allowedUDPPorts = lib.optionals (
      config.services.netbird.server.enable && config.services.netbird.server.coturn.enable
    ) config.services.netbird.server.coturn.openPorts;
  };

  security.acme.certs.netbird.domain = config.services.netbird.server.domain;

  services.nginx.virtualHosts.${config.services.netbird.server.domain} = {
    addSSL = true;
    sslCertificate = "${config.security.acme.certs.netbird.directory}/cert.pem";
    sslCertificateKey = "${config.security.acme.certs.netbird.directory}/key.pem";
  };

  # make netbird-management start in the right moment of time at startup
  systemd.services.netbird-management = {
    after = [
      "dnscrypt-proxy2.service"
      "nginx.service"
      "sing-box.service"
      "network-online.target"
      "zitadel.service"
    ];
    requires = [
      "network-online.target"
      "zitadel.service"
      "nginx.service"
    ];
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
