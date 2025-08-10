{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  uplinkMACAddress = "52:54:00:60:44:56";
in
{
  networking.nftables.firewall.rules.nixos-firewall.from = [ "uplink" ];

  boot.initrd.services.udev.rules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplinkMACAddress}", NAME="uplink"
  '';

  networking = {
    useDHCP = false;

    interfaces.uplink = {
      ipv4 = {
        addresses = lib.singleton {
          address = "185.204.3.231";
          prefixLength = 24;
        };
      };
      ipv6 = {
        addresses = lib.singleton {
          address = "2a04:5200:fff5::1f43";
          prefixLength = 48;
        };
      };
    };

    defaultGateway = {
      address = "185.204.3.1";
      interface = "uplink";
    };

    defaultGateway6 = {
      address = "2a04:5200:fff5::1";
      interface = "uplink";
    };

    nameservers = [
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
    ];
  };

  services.ddclient.usev6 = "cmdv6, cmdv6=\"'${
    lib.getExe inputs.self.packages.${pkgs.system}.getv6addresses
  }' -p -x | tr '\\n' ',' | sed 's/,*$//'\"";
}
