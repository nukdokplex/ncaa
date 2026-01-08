{
  lib,
  config,
  ...
}:
let
  domain = "pictures.nukdokplex.ru";
  cfg = config.services.immich;
in
{
  services = {
    immich = {
      enable = true;
      database = {
        enable = true;
        createDB = false;
        user = "immich";
        name = cfg.database.user;
        host = "/run/postgresql";
      };
      redis = {
        enable = true;
        port = 0;
        host = config.services.redis.servers.immich.unixSocket;
      };
      mediaLocation = "/data/pictures";
    };

    postgresql = {
      ensureUsers = lib.singleton {
        name = cfg.database.user;
        ensureDBOwnership = true;
      };
      ensureDatabases = [ cfg.database.user ];
    };

    redis = {
      servers = {
        immich = {
          enable = true;
          user = "immich";
          group = "immich";
          unixSocketPerm = 600;
        };
      };
    };

    nginx.virtualHosts.immich = {
      serverName = domain;
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://[::1]:${toString cfg.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            # set timeout
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
            send_timeout       600s;

            # allow large file uploads
            client_max_body_size 20G;
          '';
        };
      };
    };

    # oauth2-proxy.nginx.virtualHosts.immich = {
    #   allowed_roles = [ "oauth2-proxy:manage-pictures" ];
    # };
  };

  users.users.immich.extraGroups = [ "pictures" ];
}
