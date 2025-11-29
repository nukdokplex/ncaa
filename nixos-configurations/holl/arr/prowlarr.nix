{ config, ... }:
{
  services = {
    prowlarr = {
      enable = true;
      openFirewall = false;
      settings = {
        server = {
          port = 54716;
        };
      };
    };

    nginx.virtualHosts.prowlarr = {
      serverName = "prowl.arr.nukdokplex.ru";
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prowlarr.settings.server.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };

    oauth2-proxy.nginx.virtualHosts.prowlarr = {
      allowed_roles = [
        "oauth2-proxy:manage-torrents"
      ];
    };
  };
}
