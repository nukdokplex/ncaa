{ config, ... }:
let
  domain = rec {
    root = "nukdokplex.ru";
    oauth2-proxy = "oauth2-proxy.${root}";
    sso = "sso.${root}";
  };
  port = 29375;
  realm = "nukdokplex";
in
{
  services = {
    oauth2-proxy = {
      enable = true;

      reverseProxy = true;
      httpAddress = "http://[::1]:${toString port}";

      nginx = {
        domain = domain.oauth2-proxy;
        proxy = config.services.oauth2-proxy.httpAddress;
      };

      provider = "keycloak-oidc";
      oidcIssuerUrl = "https://${domain.sso}/realms/${realm}";
      redirectURL = "https://${domain.oauth2-proxy}/oauth2/callback";
      email.domains = [ "*" ];
      cookie = {
        domain = ".${domain.root}";
        secure = true;
      };
      keyFile = config.age.secrets.oauth2-proxy-secrets-env.path;
      extraConfig = {
        client-id = "oauth2-proxy";
        skip-provider-button = true;
        code-challenge-method = "S256";
        provider-display-name = "Keycloak";
        whitelist-domain = [ "*.nukdokplex.ru" ];
        session-store-type = "redis";
        redis-connection-url = "unix://${config.services.redis.servers.oauth2-proxy.unixSocket}";
        # skip-jwt-bearer-tokens = true;
      };
      setXauthrequest = true;
      passAccessToken = true;
    };

    redis.servers.oauth2-proxy = {
      enable = true;
      unixSocketPerm = 660;
      group = "oauth2-proxy";
      user = "redis-oauth2-proxy";
    };

    nginx.virtualHosts.${config.services.oauth2-proxy.nginx.domain} = {
      serverName = domain.oauth2-proxy;
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://[::1]:${toString port}";
        proxyWebsockets = true;
      };
    };
  };

  users = {
    groups.redis-oauth2-proxy = { };
    users.redis-oauth2-proxy = {
      isSystemUser = true;
      group = "redis-oauth2-proxy";
    };
  };

  systemd.services.oauth2-proxy = {
    after = [ "redis-oauth2-proxy.service" ];
    # Don't give up trying to start oauth2-proxy, even if keycloak isn't up yet
    # https://gist.github.com/benley/78a5e84c52131f58d18319bf26d52cda
    startLimitIntervalSec = 0;
    serviceConfig = {
      RestartSec = 1;
    };
  };

  age.secrets = {
    oauth2-proxy-cookie-secret = {
      intermediary = true;
      generator.script =
        { pkgs, lib, ... }: "${lib.getExe pkgs.openssl} rand -base64 32 | tr -- '+/' '-_'";
    };
    oauth2-proxy-client-secret = {
      intermediary = true;
    };
    oauth2-proxy-secrets-env = {
      generator = {
        dependencies = {
          inherit (config.age.secrets)
            oauth2-proxy-cookie-secret
            oauth2-proxy-client-secret
            ;
        };
        script =
          {
            decrypt,
            deps,
            lib,
            ...
          }:
          ''
            cat << EOF
            OAUTH2_PROXY_COOKIE_SECRET="$(${decrypt} ${lib.escapeShellArg deps.oauth2-proxy-cookie-secret.file})"
            OAUTH2_PROXY_CLIENT_SECRET="$(${decrypt} ${lib.escapeShellArg deps.oauth2-proxy-client-secret.file})"
            EOF
          '';
      };
      owner = "oauth2-proxy";
      group = "oauth2-proxy";
      mode = "0400";
    };
  };
}
