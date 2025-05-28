{
  config,
  flakeRoot,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  uplinkMACAddress = "52:54:00:60:44:56";
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
        "185.204.3.231/24"
        "2a04:5200:fff5::1f43/48"
      ];

      routes = [
        { Gateway = "185.204.3.1"; }
        { Gateway = "2a04:5200:fff5::1"; }
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

  services.ddclient.usev6 = lib.mkDefault "cmdv6, cmdv6=\"'${
    lib.getExe inputs.self.packages.${pkgs.system}.getv6addresses
  }' -p -x | tr '\\n' ',' | sed 's/,*$//'\"";
}
