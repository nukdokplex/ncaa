{
  lib,
  config,
  ...
}:
let
  cfg = config.services.netbird.server.custom;
in
{
  options = {
    services.netbird.server.custom = {
      enable = lib.mkEnableOption "Enables netbird-server";

      domain = lib.mkOption {
        type = lib.types.str;
        default = "netbird.example.com";
        description = "Netbird domain name";
      };

      clientID = lib.mkOption {
        type = lib.types.str;
        default = "netbird";
        description = "Name of netbird client from keycloak";
      };

      backendID = lib.mkOption {
        type = lib.types.str;
        default = "netbird";
        description = "Name of netbird backend client for keycloak";
      };

      keycloakDomain = lib.mkOption {
        type = lib.types.str;
        default = "auth.example.com";
        description = "Keycloak domain name";
      };

      keycloakURL = lib.mkOption {
        type = lib.types.str;
        default = "https://${cfg.keycloakDomain}/";
        description = "Path to root keycloak";
      };

      keycloakRealmName = lib.mkOption {
        type = lib.types.str;
        default = "example";
        description = "Name of keycloak realm";
      };

      coturnPasswordPath = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.str
          lib.types.path
        ];
        default = "/run/secrets/netbird/coturnPassword";
        description = "Path to coturn password file";
      };

      coturnSalt = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.str
          lib.types.path
        ];
        default = "/run/secrets/netbird/coturnPassword";
        description = "Path to coturn password file";
      };

      dataStoreEncryptionKeyPath = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.str
          lib.types.path
        ];
        default = "/run/secrets/netbird/DataStoreEncryptionKeyPath";
        description = "Path to datastore enc key file";
      };

      clientSecretPath = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.str
          lib.types.path
        ];
        default = "/run/secrets/netbird/clientSecret";
        description = "Path to client secret file for netbird backend";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.netbird.server = {
      inherit (cfg) domain;

      enable = true;

      signal = {
        enable = true;
        enableNginx = true;
      };

      coturn = {
        enable = true;
        passwordFile = cfg.coturnPasswordPath;
      };

      dashboard = {
        enableNginx = true;
        settings = {
          AUTH_AUTHORITY = "${cfg.keycloakURL}/realms/${cfg.keycloakRealmName}";
          AUTH_AUDIENCE = cfg.clientID;
          AUTH_CLIENT_ID = cfg.clientID;
          AUTH_SUPPORTED_SCOPES = "openid profile email offline_access api";
          USE_AUTH0 = false;
        };
      };

      management = {
        enableNginx = true;
        oidcConfigEndpoint = "${cfg.keycloakURL}/realms/${cfg.keycloakRealmName}/.well-known/openid-configuration";

        settings = {
          DataStoreEncryptionKey._secret = cfg.dataStoreEncryptionKeyPath;

          TURNConfig = {
            Secret._secret = cfg.coturnSalt;

            Turns = [
              {
                Proto = "udp";
                URI = "turn:${cfg.domain}:3478";
                Username = "netbird";
                Password._secret = cfg.coturnPasswordPath;
              }
            ];
          };

          HttpConfig = {
            AuthAudience = cfg.clientID;
            AuthIssuer = "${cfg.keycloakURL}/realms/${cfg.keycloakRealmName}";
            AuthKeysLocation = "${cfg.keycloakURL}/realms/${cfg.keycloakRealmName}/openid-connect/certs";
            IdpSignKeyRefreshEnabled = false;
          };

          IdpManagerConfig = {
            ManagerType = "keycloak";

            ClientConfig = {
              Issuer = "${cfg.keycloakURL}/realms/${cfg.keycloakRealmName}";
              TokenEndpoint = "${cfg.keycloakURL}/realms/${cfg.keycloakRealmName}/protocol/openid-connect/token";
              ClientID = cfg.backendID;
              ClientSecret._secret = cfg.clientSecretPath;
            };

            ExtraConfig = {
              AdminEndpoint = "${cfg.keycloakURL}/admin/realms/${cfg.keycloakRealmName}";
            };
          };

          DeviceAuthorizationFlow = {
            Provider = "hosted";

            ProviderConfig = {
              ClientID = cfg.clientID;
              Audience = cfg.clientID;
              Domain = cfg.keycloakDomain;
              TokenEndpoint = "${cfg.keycloakURL}/realms/${cfg.keycloakRealmName}/protocol/openid-connect/token";
              DeviceAuthEndpoint = "${cfg.keycloakURL}/realms/${cfg.keycloakRealmName}/protocol/openid-connect/auth/device";
              Scope = "openid";
              UseIDToken = false;
            };
          };

          PKCEAuthorizationFlow = {
            ProviderConfig = {
              ClientID = cfg.clientID;
              Audience = cfg.clientID;
              TokenEndpoint = "${cfg.keycloakURL}/realms/${cfg.keycloakRealmName}/protocol/openid-connect/token";
              AuthorizationEndpoint = "${cfg.keycloakURL}/realms/${cfg.keycloakRealmName}/protocol/openid-connect/auth";
            };
          };
        };
      };
    };
  };
}
