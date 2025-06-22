{
  lib,
  pkgs,
  config,
  flakeRoot,
  ...
}:
let
  getDeviceId = hostname: builtins.readFile (flakeRoot + /secrets/generated/${hostname}/syncthing-id);
  getPublicKeyPath = hostname: flakeRoot + /secrets/generated/${hostname}/syncthing-public.pem;
in
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    key = config.age.secrets.syncthing.path;
    cert = toString (
      pkgs.writeText "syncthing-public-key" (
        builtins.readFile (getPublicKeyPath config.networking.hostName)
      )
    );
    settings =
      let
        devices = {
          sleipnir = {
            id = getDeviceId "sleipnir";
          };
          gladr = {
            id = getDeviceId "gladr";
          };
          hrafn = {
            id = "EC4RLTB-CKAH2DZ-KVQNUC6-CEKMG43-T73DRAY-ZXOHBHO-OS2AIL4-BKMZOQQ";
          };
        };

        folders = {
          pictures = {
            path = "/home/nukdokplex/pictures";
            devices = [
              "sleipnir"
              "gladr"
              "hrafn"
            ];
            type = "sendreceive";
            versioning = {
              type = "staggered";
              params = {
                cleanInterval = "3600";
                maxAge = "31536000"; # 365d
              };
            };
          };
          pictures2 = {
            path = "/home/nukdokplex/pictures2";
            devices = [
              "sleipnir"
              "gladr"
              "hrafn"
            ];
            type = "sendreceive";
            versioning = {
              type = "simple";
              params.keep = "50";
            };
          };
          documents = {
            path = "/home/nukdokplex/documents";
            devices = [
              "sleipnir"
              "gladr"
              "hrafn"
            ];
            type = "sendreceive";
            versioning = {
              type = "staggered";
              params = {
                cleanInterval = "3600";
                maxAge = "31536000"; # 365d
              };
            };
          };
          music = {
            path = "/home/nukdokplex/music";
            devices = [
              "sleipnir"
              "gladr"
              "hrafn"
            ];
            type = "sendreceive";
            versioning = {
              type = "trashcan";
              params.cleanoutDays = "7";
            };
          };
          publicShare = {
            path = "/home/nukdokplex/publicShare";
            devices = [
              "sleipnir"
              "gladr"
              "hrafn"
            ];
            type = "sendreceive";
          };
        };
        hostEnabledFolders = lib.filterAttrs (
          n: v: builtins.elem config.networking.hostName v.devices
        ) folders;
      in
      {
        options = {
          urAccepted = -1;
          relaysEnabled = true;
          localAnnounceEnabled = true;
        };

        devices = lib.filterAttrs (n: v: n != config.networking.hostName) devices;
        folders = lib.mapAttrs (
          n: v: v // { devices = lib.remove config.networking.hostName v.devices; }
        ) hostEnabledFolders;
      };
  };

  systemd.services.syncthing.serviceConfig = rec {
    AmbientCapabilities = [
      # pending nixos/nixpkgs#338485
      "CAP_CHOWN"
      "CAP_DAC_OVERRIDE"
      "CAP_FOWNER"
    ];
    CapabilitiesBoundingSet = AmbientCapabilities;
    PrivateUsers = lib.mkForce false;
  };

  networking.nftables.tables.filter.content =
    lib.mkIf (config.services.syncthing.enable && config.services.syncthing.openDefaultPorts)
      ''
        chain post_input_hook {
          tcp dport 22000 counter accept
          udp dport { 21027, 22000 } counter accept
        }
      '';

  age.secrets.syncthing = {
    generator.script = "syncthing-keypair";
    mode = "400";
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };
}
