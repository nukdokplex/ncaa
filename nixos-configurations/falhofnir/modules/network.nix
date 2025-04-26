{ config, flakeRoot, lib, ... }: let
  uplinkMACAddress = "00:16:3c:63:bd:c6";
in {
  networking.useDHCP = false;

  boot.initrd.services.udev.rules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplinkMACAddress}", NAME="uplink"
  '';

  systemd.network = lib.fix (self: {
    enable = true;
    networks.uplink = {
      matchConfig.MACAddress = uplinkMACAddress;
    };
  });

  networking.nat = {
    enable = true;
    enableIPv6 = true; # Viatcheslav negoduet 
    externalInterface = "uplink";
  };

  # systemd drop-in to keep address secret
  age.secrets.uplink-address = {
    path = "/run/systemd/network/uplink.network.d/address.conf";
    rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/uplink-address.age;
    owner = "systemd-network";
    group = "systemd-network";
  };
}
