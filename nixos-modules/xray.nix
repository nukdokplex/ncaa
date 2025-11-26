{
  lib,
  pkgs,
  config,
  utils,
  ...
}:
let
  settingsFormat = pkgs.formats.json { };
in
{
  # disable original nixos module
  disabledModules = lib.singleton "services/networking/xray.nix";

  options.services.xray = {
    enable = lib.mkEnableOption "xray server";
    package = lib.mkPackageOption pkgs "xray" { };
    extraOpts = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = "Extra command line options to use.";
    };
    settings = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule {
          freeformType = settingsFormat.type;
        }
      );
      default = null;
      example = {
        inbounds = [
          {
            port = 1080;
            listen = "127.0.0.1";
            protocol = "http";
          }
        ];
        outbounds = [
          {
            protocol = "freedom";
          }
        ];
      };
      description = ''
        Xray service configuration, see <https://xtls.github.io/en/config/> for configuration documentation.

        Options containing secret data shoud be set to an attribute set
        containing the attribute `_secret` - a string pointing to a file
        containing the value the option should be set to.
      '';
    };

    settingsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/etc/xray/config.json";
      description = ''
        The absolute path to the configuration file.

        See <https://xtls.github.io/en/config/>.
      '';
    };
  };

  config =
    let
      cfg = config.services.xray;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = (cfg.settings == null) != (cfg.settingsFile == null);
          message = "Either but not both `settingsFile` and `settings` should be specified for xray.";
        }
      ];

      systemd.services = {
        # xray-init = {
        #   description = "Setup service for xray.service, generates config with credentials";
        #   inherit (config.systemd.services.xray) documentation;
        #   requiredBy = [ "xray.service" ];
        #   before = [ "xray.service" ];
        #   script = ''
        #     touch /run/xray-config.json
        #     chmod 0600 /run/xray-config.json
        #     ${utils.genJqSecretsReplacementSnippet cfg.settings "/run/xray-config.json"}
        #   '';
        #   serviceConfig = {
        #     Type = "oneshot";
        #     RemainAfterExit = true;
        #   };
        # };
        xray = {
          description = "Xray daemon";
          documentation = [ "https://xtls.github.io/en/" ];
          requires = [ "network-online.target" ];
          after = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            DynamicUser = true;
            RuntimeDirectory = "xray";
            RuntimeDirectoryMode = "0700";

            ExecStartPre =
              let
                script = pkgs.writeShellScript "xray-pre-start" (
                  if cfg.settingsFile == null then
                    utils.genJqSecretsReplacementSnippet cfg.settings "/run/xray/config.json"
                  else
                    ''cp ${lib.escapeShellArg cfg.settingsFile} "/run/xray/config.json"''
                );
              in
              "+${script}";

            ExecStart = lib.concatStringsSep " " (
              [
                (lib.getExe cfg.package)
                "run"
                ''-config="/run/xray/config.json"''
              ]
              ++ lib.optional (cfg.extraOpts != null) cfg.extraOpts
            );

            # hardening

            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = "disconnected";
            PrivateDevices = true;
            PrivateMounts = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            LockPersonality = true;
            RestrictRealtime = true;
            ProtectClock = true;
            MemoryDenyWriteExecute = true;
            ReadOnlyPaths = [ "-/" ];
            TemporaryFileSystem = [ "/:ro" ];
            BindReadOnlyPaths = [
              "-/nix/store"
              "-/etc"
              "-/proc"
              "-/run"
              "-/sys"
              "-/var"
            ];
            NoExecPaths = [ "/" ];
            ExecPaths = [ "/nix/store/" ];
            RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
            CapabilityBoundingSet = [
              "~CAP_BLOCK_SUSPEND CAP_BPF CAP_CHOWN CAP_IPC_LOCK CAP_KILL CAP_MKNOD CAP_NET_RAW CAP_PERFMON CAP_SYS_BOOT CAP_SYS_CHROOT CAP_SYS_MODULE CAP_SYS_NICE CAP_SYS_PACCT CAP_SYS_PTRACE CAP_SYS_TIME CAP_SYS_TTY_CONFIG CAP_SYSLOG CAP_WAKE_ALARM"
              "CAP_NET_BIND_SERVICE"
            ];
            AmbientCapabilities = [
              "CAP_NET_BIND_SERVICE"
            ];
            SystemCallFilter = "~@aio:EPERM @chown:EPERM @clock:EPERM @cpu-emulation:EPERM @debug:EPERM @ipc:EPERM @keyring:EPERM @memlock:EPERM @module:EPERM @mount:EPERM @obsolete:EPERM @pkey:EPERM @privileged:EPERM @raw-io:EPERM @reboot:EPERM @resources:EPERM @sandbox:EPERM @setuid:EPERM @swap:EPERM @sync:EPERM @timer:EPERM";
          };
        };
      };
    };
}
