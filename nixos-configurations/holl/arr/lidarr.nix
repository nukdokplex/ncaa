{
  config,
  pkgs,
  lib,
  ...
}:
{
  assertions = [
    {
      assertion = lib.versionOlder config.system.nixos.release "26.05";
      message = "You should renovate postgresql settings in holl's lidarr module with new ensures.";
    }
  ];

  services = {
    lidarr = {
      package = pkgs.lidarr-plugins;
      enable = true;
      user = "lidarr";
      group = "lidarr";
      environmentFiles = [ config.age.secrets.lidarr-postgresql-env.path ];
      openFirewall = false;
      settings = {
        server = {
          port = 65394;
        };
      };
    };

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
        proxyPass = "http://127.0.0.1:${toString config.services.lidarr.settings.server.port}";
      };
    };

    oauth2-proxy.nginx.virtualHosts.lidarr = {
      allowed_roles = [
        "oauth2-proxy:manage-music"
      ];
    };
  };

  systemd.services.lidarr = {
    serviceConfig = {
      ProtectSystem = "full";
      PrivateMounts = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      LockPersonality = true;
      RestrictRealtime = true;
      ProtectClock = true;
      RestrictAddressFamilies = "AF_INET AF_INET6 AF_NETLINK AF_UNIX";
      SocketBindDeny = "any";
      SocketBindAllow = [
        "ipv4:tcp:${toString config.services.lidarr.settings.server.port}"
        "ipv6:tcp:${toString config.services.lidarr.settings.server.port}"
      ];
      CapabilityBoundingSet = "~CAP_BLOCK_SUSPEND CAP_BPF CAP_CHOWN CAP_IPC_LOCK CAP_MKNOD CAP_NET_RAW CAP_PERFMON CAP_SYS_BOOT CAP_SYS_CHROOT CAP_SYS_MODULE CAP_SYS_PACCT CAP_SYS_PTRACE CAP_SYS_TIME CAP_SYSLOG CAP_WAKE_ALARM";
      SystemCallFilter = "~@aio:EPERM @chown:EPERM @clock:EPERM @cpu-emulation:EPERM @debug:EPERM @keyring:EPERM @memlock:EPERM @module:EPERM @mount:EPERM @obsolete:EPERM @pkey:EPERM @privileged:EPERM @raw-io:EPERM @reboot:EPERM @sandbox:EPERM @setuid:EPERM @swap:EPERM @sync:EPERM @timer:EPERM";

    };
  };

  users.users.lidarr.extraGroups = [ "music" ];

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
            LIDARR__POSTGRES__HOST=localhost
            LIDARR__POSTGRES__PORT=5432
            LIDARR__POSTGRES__USER=lidarr
            LIDARR__POSTGRES__PASSWORD="$(${decrypt} ${lib.escapeShellArg deps.password.file})"
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
