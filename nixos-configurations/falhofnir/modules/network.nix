{ config, flakeRoot, lib, ... }: {
  networking.useDHCP = false;
  systemd.network = lib.fix (self: {
    enable = true;
    links.uplink = {
      matchConfig.MACAddress = "00:16:3c:63:bd:c6";
      linkConfig.Alias = "uplink";
      linkConfig.AlternativeName = "uplink";
    };
    networks.uplink = {
      matchConfig = self.links.uplink.matchConfig;
    };
  });

  networking.nat = {
    enable = true;
    externalInterface = config.systemd.network.links.uplink.linkConfig.AlternativeName;
  };

  # systemd drop-in to keep address secret
  age.secrets.uplink-address = {
    path = "/run/systemd/network/uplink.network.d/address.conf";
    rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/uplink-address.age;
    owner = "systemd-network";
    group = "systemd-network";
  };
}
