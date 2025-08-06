{ lib, ... }:
let
  uplinkMACAddress = "52:54:00:97:21:bc";
in
{
  boot.initrd.services.udev.rules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplinkMACAddress}", NAME="uplink"
  '';

  networking = {
    useDHCP = true;

    interfaces.uplink = {
      ipv4 = {
        addresses = lib.singleton {
          address = "192.168.122.69";
          prefixLength = 24;
        };
      };
      ipv6 = {
        addresses = lib.singleton {
          address = "feee:122::69";
          prefixLength = 64;
        };
      };
    };

    defaultGateway = {
      address = "192.168.122.1";
      interface = "uplink";
    };

    defaultGateway6 = {
      address = "feee:122::1";
      interface = "uplink";
    };

    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
}
