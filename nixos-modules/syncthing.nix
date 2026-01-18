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
  devices = {
    sleipnir = {
      id = getDeviceId "sleipnir";
      addresses = [
        "quic://sleipnir.ndp.local:22000"
        "tcp://sleipnir.ndp.local:22000"
      ];
    };
    gladr = {
      id = getDeviceId "gladr";
      addresses = [
        "quic://gladr.ndp.local:22000"
        "tcp://gladr.ndp.local:22000"
      ];
    };
    holl = {
      id = getDeviceId "holl";
      addresses = [
        "quic://holl.ndp.local:22000"
        "tcp://holl.ndp.local:22000"
      ];
    };
    hrafn = {
      id = "EC4RLTB-CKAH2DZ-KVQNUC6-CEKMG43-T73DRAY-ZXOHBHO-OS2AIL4-BKMZOQQ";
      addresses = [
        "quic://hrafn.ndp.local:22000"
        "tcp://hrafn.ndp.local:22000"
      ];
    };
  };
  folders = {
    hrafn-camera = {
      path = "/home/nukdokplex/pictures/hrafn-camera";
      devices = [
        "hrafn"
        "holl"
      ];
      type = "sendreceive";
      ignorePerms = true;
      versioning = {
        type = "trashcan";
        params.cleanoutDays = "7";
      };
    };
    hrafn-screenshots = {
      path = "/home/nukdokplex/pictures/hrafn-screenshots";
      devices = [
        "hrafn"
        "holl"
      ];
      type = "sendreceive";
      ignorePerms = true;
      versioning = {
        type = "trashcan";
        params.cleanoutDays = "7";
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
  };
in
{
  assertions = [
    {
      assertion = devices ? "${config.networking.hostName}";
      message = ''Can't find "${config.networking.hostName}" in syncthing configuration. Consider adding device or removing import of this module.'';
    }
  ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    key = config.age.secrets.syncthing.path;
    cert = toString (
      pkgs.writeText "syncthing-public-key" (
        builtins.readFile (getPublicKeyPath config.networking.hostName)
      )
    );
    guiPasswordFile = config.age.secrets.syncthing-gui-password.path;
    settings =
      let
        hostEnabledFolders = lib.filterAttrs (
          _: v: builtins.elem config.networking.hostName v.devices
        ) folders;
      in
      {
        options = {
          urAccepted = -1; # usage reporting, -1 means don't send any usage data
          localAnnounceEnabled = false;
          globalAnnounceEnabled = false;
          relaysEnabled = false;
          natEnabled = false;
          gui.user = "nukdokplex";
        };

        devices = lib.filterAttrs (n: _: n != config.networking.hostName) devices;
        folders = lib.mapAttrs (
          _: v: v // { devices = lib.remove config.networking.hostName v.devices; }
        ) hostEnabledFolders;
      };
  };

  networking.nftables.firewall.rules.open-ports-trusted.allowedTCPPorts = lib.mkIf (
    config.services.syncthing.enable && config.services.syncthing.openDefaultPorts
  ) [ 22000 ];

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

  age.secrets.syncthing = {
    generator.script = "syncthing-keypair";
    mode = "400";
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };

  age.secrets.syncthing-gui-password = {
    rekeyFile = flakeRoot + /secrets/non-generated/common/syncthing-gui-password.age;
    mode = "400";
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };

}
