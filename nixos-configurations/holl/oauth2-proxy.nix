{ config, ... }:
let
  domain = rec {
    root = "nukdokplex.ru";
    oauth2-proxy = "oauth2-proxy.${root}";
    sso = "sso.${root}";
  };
  port = 29375;
in
{
  services.oauth2-proxy = {
    enable = true;

    reverseProxy = true;
    httpAddress = "http://[::1]:${toString port}";

    nginx = {
      domain = domain.oauth2-proxy;
      proxy = config.services.oauth2-proxy.httpAddress;
    };

    provider = "oidc";
    oidcIssuerUrl = "https://${domain.sso}";
    redirectURL = "https://${domain.oauth2-proxy}/oauth2/callback";
    email.domains = [ "*" ];
    cookie = {
      domain = ".${domain.root}";
      secure = true;
    };
    keyFile = config.age.secrets.oauth2-proxy-secrets-env.path;
    extraConfig = {
      client-id = "343961469550942214";
      user-id-claim = "sub";
      skip-provider-button = true;
      code-challenge-method = "S256";
      provider-display-name = "ZITADEL";
      whitelist-domain = [ "*.nukdokplex.ru" ];
      skip-jwt-bearer-tokens = true;
      oidc-groups-claim = "oauth2-proxy:groups"; # claim added by zitadel action
    };
    setXauthrequest = true;
    passAccessToken = true;
  };

  services.nginx.virtualHosts.${config.services.oauth2-proxy.nginx.domain} = {
    serverName = domain.oauth2-proxy;
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://[::1]:${toString port}";
      proxyWebsockets = true;
    };
  };

  age.secrets = {
    oauth2-proxy-cookie-secret = {
      generator.script =
        { pkgs, lib, ... }: "${lib.getExe pkgs.openssl} rand -base64 32 | tr -- '+/' '-_'";
    };
    oauth2-proxy-client-secret = { };
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
