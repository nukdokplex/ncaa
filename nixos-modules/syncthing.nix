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
  cfg = config.services.syncthing;
  isUnixGui = (builtins.substring 0 1 cfg.guiAddress) == "/";

  # Syncthing supports serving the GUI over Unix sockets. If that happens, the
  # API is served over the Unix socket as well.  This function returns the correct
  # curl arguments for the address portion of the curl command for both network
  # and Unix socket addresses.
  curlAddressArgs =
    path:
    if
      isUnixGui
    # if cfg.guiAddress is a unix socket, tell curl explicitly about it
    # note that the dot in front of `${path}` is the hostname, which is
    # required.
    then
      "--unix-socket ${cfg.guiAddress} http://.${path}"
    # no adjustments are needed if cfg.guiAddress is a network address
    else
      "${cfg.guiAddress}${path}";

  updateGuiCredentials = pkgs.writers.writeBash "update-syncthing-gui-credentials" ''
    set -efu

    # be careful not to leak secrets in the filesystem or in process listings
    umask 0077

    curl() {
        # get the api key by parsing the config.xml
        while
            ! ${pkgs.libxml2}/bin/xmllint \
                --xpath 'string(configuration/gui/apikey)' \
                ${cfg.configDir}/config.xml \
                >"$RUNTIME_DIRECTORY/api_key"
        do sleep 1; done
        (printf "X-API-Key: "; cat "$RUNTIME_DIRECTORY/api_key") >"$RUNTIME_DIRECTORY/headers"
        ${pkgs.curl}/bin/curl -sSLk -H "@$RUNTIME_DIRECTORY/headers" \
            --retry 1000 --retry-delay 1 --retry-all-errors \
            "$@"
    }

    curl -X PUT -d "{ \"user\": \"nukdokplex\", \"password\": \"$(cat ${config.age.secrets.syncthing-hashed-password.path})\" }" ${curlAddressArgs "/rest/config/gui"}
  '';
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
              "gladr"
              "hrafn"
            ];
            type = "sendreceive";
          };
        };
        hostEnabledFolders = lib.filterAttrs (
          _: v: builtins.elem config.networking.hostName v.devices
        ) folders;
      in
      {
        options = {
          urAccepted = -1;
          relaysEnabled = true;
          localAnnounceEnabled = true;
        };

        devices = lib.filterAttrs (n: _: n != config.networking.hostName) devices;
        folders = lib.mapAttrs (
          _: v: v // { devices = lib.remove config.networking.hostName v.devices; }
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

  systemd.services.syncthing-init.serviceConfig.ExecStartPre = updateGuiCredentials;

  age.secrets.syncthing = {
    generator.script = "syncthing-keypair";
    mode = "400";
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };

  age.secrets.syncthing-hashed-password = {
    rekeyFile = flakeRoot + /secrets/non-generated/common/syncthing-hashed-password.age;
    mode = "400";
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };

}
