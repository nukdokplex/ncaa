{
  config,
  flakeRoot,
  lib,
  ...
}:
let
  uplinkMACAddress = "00:16:3c:63:bd:c6";
in
{
  networking.useDHCP = false;

  boot.initrd.services.udev.rules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplinkMACAddress}", NAME="uplink"
  '';

  systemd.network = lib.fix (self: {
    enable = true;
    networks.uplink = {
      address = [
        "188.253.26.208/24"
        "2a0c:16c2:500:663:216:3cff:fe63:bdc6/48"
      ];

      routes = [
        { Gateway = "188.253.26.1"; }
        { Gateway = "2a0c:16c2:500::1"; }
      ];

      dns = [
        "[2606:4700:4700::1111]:53"
        "[2606:4700:4700::1001]:53"
      ];

      matchConfig.MACAddress = uplinkMACAddress;
      networkConfig = {
        IPv6AcceptRA = false;
        LinkLocalAddressing = false;
      };

    };
  });
}
