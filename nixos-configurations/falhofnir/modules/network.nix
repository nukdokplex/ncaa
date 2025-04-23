{ config, flakeRoot, lib, ... }: let
  uplink = "enx" + (lib.toLower (builtins.replaceStrings [ ":" ] [ "" ] config.systemd.network.networks.uplink.matchConfig.MACAddress));
in {
  networking.useDHCP = false;
  systemd.network = lib.fix (self: {
    enable = true;
    networks.uplink = {
      matchConfig.MACAddress = "00:16:3c:63:bd:c6";
    };
  });

  networking.nat = {
    enable = true;
    externalInterface = uplink;
  };

  # systemd drop-in to keep address secret
  age.secrets.uplink-address = {
    path = "/run/systemd/network/uplink.network.d/address.conf";
    rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/uplink-address.age;
    owner = "systemd-network";
    group = "systemd-network";
  };
}
