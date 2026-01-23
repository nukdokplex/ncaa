{
  config,
  lib,
  ...
}:
let
  internalPort = 65394;
in
{
  assertions = [
    {
      assertion = lib.versionOlder config.system.nixos.release "26.05";
      message = "You should renovate postgresql settings in holl's lidarr module with new ensures.";
    }
  ];

  virtualisation.oci-containers.containers = {
    lidarr = {
      image = "ghcr.io/hotio/lidarr:nightly-fca0048";

      volumes = [
        "/var/lib/lidarr:/config"
        "/data/music/managed:/data/music/managed"
        "/data/torrents:/data/torrents:ro"
      ];

      environmentFiles = [ config.age.secrets.lidarr-postgresql-env.path ];
      environment = {
        PUID = toString config.users.users.lidarr.uid;
        PGID = toString config.users.groups.lidarr.gid;
        LIDARR__SERVER__PORT = toString internalPort;
      };

      extraOptions = [
        "--network=host"
      ];
    };
  };

  services = {
    # user password and db ownership should be set manually
    postgresql = {
      ensureDatabases = [
        "lidarr-main"
        "lidarr-log"
      ];
      ensureUsers = lib.singleton {
        name = "lidarr";
      };
    };

    nginx.virtualHosts.lidarr = {
      serverName = "lid.arr.nukdokplex.ru";
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        recommendedProxySettings = true;
        proxyWebsockets = true;
        proxyPass = "http://127.0.0.1:${toString internalPort}";
      };
    };

    oauth2-proxy.nginx.virtualHosts.lidarr = {
      allowed_roles = [
        "oauth2-proxy:manage-music"
      ];
    };
  };

  users = {
    groups.lidarr = {
      gid = 306;
    };

    users.lidarr = {
      uid = 306;
      isSystemUser = true;
      group = "lidarr";
      extraGroups = [ "music" ];
    };
  };

  age.secrets = {
    lidarr-postgresql-password = {
      intermediary = true;
      generator = {
        tags = [ "lidarr" ];
        script = "strong-password";
      };
      owner = "lidarr";
      group = "lidarr";
      mode = "0400";
    };

    lidarr-postgresql-env = {
      generator = {
        tags = [ "lidarr" ];
        dependencies.password = config.age.secrets.lidarr-postgresql-password;
        script =
          {
            lib,
            deps,
            decrypt,
            ...
          }:
          ''
            cat << EOF
            LIDARR__POSTGRES__HOST=127.0.0.1
            LIDARR__POSTGRES__PORT=5432
            LIDARR__POSTGRES__USER=lidarr
            LIDARR__POSTGRES__PASSWORD=$(${decrypt} ${lib.escapeShellArg deps.password.file})
            LIDARR__POSTGRES__MAINDB=lidarr-main
            LIDARR__POSTGRES__LOGDB=lidarr-log
            EOF
          '';
      };
      owner = "lidarr";
      group = "lidarr";
      mode = "0400";
    };
  };
}
