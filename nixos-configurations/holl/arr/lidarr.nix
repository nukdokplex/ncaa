{ config, pkgs, ... }:
{
  services = {
    lidarr = {
      package = pkgs.lidarr-plugins;
      enable = true;
      user = "lidarr";
      group = "lidarr";
      openFirewall = false;
      settings = {
        server = {
          port = 65394;
        };
      };
    };

    # postgresql = {
    #   ensureDatabases = lib.singleton "lidarr";
    #   ensureUsers = lib.singleton {
    #     name = "lidarr";
    #     ensureDBOwnership = true;
    #   };
    # };

    nginx.virtualHosts.lidarr = {
      serverName = "lid.arr.nukdokplex.ru";
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        recommendedProxySettings = true;
        proxyWebsockets = true;
        proxyPass = "http://127.0.0.1:${toString config.services.lidarr.settings.server.port}";
      };
    };

    oauth2-proxy.nginx.virtualHosts.lidarr = {
      allowed_roles = [
        "oauth2-proxy:manage-music"
      ];
    };
  };

  users.users.lidarr.extraGroups = [ "music" ];
}
