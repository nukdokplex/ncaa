{ config, lib, ... }:
let
  ssoDomain = "sso.nukdokplex.ru";
  backendClientId = "netbird-backend";
  authClientId = "netbird-client";
  realm = "nukdokplex";
  cfg = config.services.netbird.server;
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
        AUTH_AUDIENCE = authClientId;
        AUTH_CLIENT_ID = authClientId;
        AUTH_CLIENT_SECRET = "";
        AUTH_AUTHORITY = "https://${ssoDomain}/realms/${realm}";
        USE_AUTH0 = false;
        AUTH_SUPPORTED_SCOPES = "openid profile email offline_access api";
        AUTH_REDIRECT_URI = "/#callback";
        AUTH_SILENT_REDIRECT_URI = "/#silent-callback";
        NETBIRD_TOKEN_SOURCE = "accessToken";
      };
    };

    management = {
      enableNginx = true;
      port = 23461;
      oidcConfigEndpoint = "https://${ssoDomain}/realms/${realm}/.well-known/openid-configuration";
      disableSingleAccountMode = true;
      disableAnonymousMetrics = true;
      dnsDomain = "ndp.local";

      settings = {
        DataStoreEncryptionKey._secret = config.age.secrets.netbird-datastore-encryption-key.path;
        Stuns = [
          {
            Proto = "udp";
            URI = "stun:${cfg.coturn.domain}:3478";
            Username = "";
            Password = null;
          }
        ];
        TURNConfig = {
          Turns = [
            {
              Proto = "udp";
              URI = "turn:${cfg.coturn.domain}:3478";
              Username = "netbird";
              Password._secret = config.age.secrets.netbird-coturn-password.path;
            }
          ];
          CredentialsTTL = "12h";
          Secret._secret = config.age.secrets.netbird-coturn-salt.path;
        };
        # Relay = { };
        # Signal = { }; # managed by nixos module
        DisableDefaultPolicy = false;
        StoreConfig = {
          Engine = "postgres";
        };
        HttpConfig = {
          # managed by nixos
          # Address = "0.0.0.0:33073";
          AuthAudience = authClientId;
          AuthIssuer = "https://${ssoDomain}/realms/${realm}";
          AuthKeysLocation = "https://${ssoDomain}/realms/${realm}/protocol/openid-connect/certs";
          AuthUserIDClaim = "";
          CertFile = "";
          CertKey = "";
          IdpSignKeyRefreshEnabled = false;
          OIDCConfigEndpoint = cfg.management.oidcConfigEndpoint;
        };
        IdpManagerConfig = {
          ManagerType = "keycloak";
          ClientConfig = {
            Issuer = "https://${ssoDomain}/realms/${realm}";
            TokenEndpoint = "https://${ssoDomain}/realms/${realm}/protocol/openid-connect/token";
            ClientID = backendClientId;
            ClientSecret._secret = config.age.secrets.netbird-backend-client-secret.path;
            GrantType = "client_credentials";
          };
          ExtraConfig = {
            AdminEndpoint = "https://${ssoDomain}/admin/realms/${realm}";
            ManagementEndpoint = "https://${ssoDomain}/management/v1";
          };
          Auth0ClientCredentials = null;
          AzureClientCredentials = null;
          KeycloakClientCredentials = null;
          ZitadelClientCredentials = null;
        };
        DeviceAuthorizationFlow = {
          Provider = "hosted";
          ProviderConfig = {
            Audience = authClientId;
            AuthorizationEndpoint = "";
            ClientID = authClientId;
            ClientSecret = "";
            DeviceAuthEndpoint = "https://${ssoDomain}/oauth/v2/device_authorization";
            Domain = "";
            RedirectURLs = null;
            Scope = "openid";
            TokenEndpoint = "https://${ssoDomain}/oauth/v2/token";
            UseIDToken = false;
          };
        };
        PKCEAuthorizationFlow = {
          ProviderConfig = {
            Audience = authClientId;
            ClientID = authClientId;
            ClientSecret = "";
            Domain = "";
            AuthorizationEndpoint = "https://${ssoDomain}/oauth/v2/authorize";
            TokenEndpoint = "https://${ssoDomain}/oauth/v2/token";
            Scope = "openid profile email offline_access api";
            RedirectURLs = [ "http://localhost:53000" ];
            UseIDToken = false;
            DisablePromptLogin = false;
            LoginFlag = 0;
          };
        };
      };
    };
  };

  services.postgresql = {
    ensureUsers = lib.singleton {
      name = "netbird";
      ensureDBOwnership = true;
    };
    ensureDatabases = lib.singleton "netbird";
  };

  systemd.services.netbird-management = {
    after = [
      "nginx.service"
      "network-online.target"
      "keycloak.service"
    ];
    requires = [
      "network-online.target"
      "keycloak.service"
      "nginx.service"
      "postgresql.service"
    ];
    serviceConfig = {
      EnvironmentFile = config.age.secrets.netbird-pgsql-dsn.path;
    };
  };

  networking.nftables.firewall.rules.open-ports-uplink = {
    allowedTCPPorts = cfg.coturn.openPorts;
    allowedUDPPorts = cfg.coturn.openPorts;
  };

  services.nginx.virtualHosts.${config.services.netbird.server.domain} = {
    forceSSL = true;
    enableACME = true;
  };

  age.secrets = {
    netbird-coturn-password = {
      generator.script = "strong-password";
      owner = "turnserver";
      group = "turnserver";
    };
    netbird-coturn-salt = {
      generator.script = "strong-password";
    };
    netbird-backend-client-secret = {
    };
    netbird-database-password = {
      intermediary = true;
      generator.script = "strong-password";
    };
    netbird-pgsql-dsn = {
      generator = {
        dependencies = {
          password = config.age.secrets.netbird-database-password;
        };
        script =
          {
            lib,
            decrypt,
            deps,
            ...
          }:
          ''
            echo "NETBIRD_STORE_ENGINE_POSTGRES_DSN=\"host=::1 user=netbird password=$(${decrypt} ${lib.escapeShellArg deps.password.file}) dbname=netbird  port=5432\""
          '';
      };
    };
    netbird-datastore-encryption-key = {
      generator.script = { pkgs, lib, ... }: "'${lib.getExe pkgs.openssl}' rand -base64 32";
    };
  };
}
