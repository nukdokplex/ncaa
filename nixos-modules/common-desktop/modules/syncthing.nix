{ lib, config, ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      options = {
        urAccepts = -1;
        relaysEnabled = true;
      };
      localAnnounceEnabled = true;
    };
  };

  systemd.services.syncthing.serviceConfig = {
    AmbientCapabilities = [
      "CAP_CHOWN"
      "CAP_FOWNER"
    ];
    PrivateUsers = lib.mkForce false;
  };

  age.secrets.syncthing-cert = {
    mode = "400";
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
    path = "${config.services.synthing.configDir}/cert.pem";
  };

  age.secrets.syncthing-key = {
    mode = "400";
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
    path = "${config.services.synthing.configDir}/key.pem";
  };
}
