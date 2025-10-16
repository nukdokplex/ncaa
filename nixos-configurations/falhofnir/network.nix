{
  lib,
  pkgs,
  ...
}:
let
  uplinkMACAddress = "00:16:3c:63:bd:c6";
in
{
  networking.nftables.firewall.snippets.nnf-dhcpv6.enable = lib.mkForce false;

  boot = {
    initrd.services.udev.rules = ''
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplinkMACAddress}", NAME="uplink0"
    '';
    kernelModules = [ "nf_nat_ftp" ];
    kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = lib.mkOverride 99 true;
      "net.ipv4.conf.default.forwarding" = lib.mkOverride 99 true;

      # Do not prevent IPv6 autoconfiguration.
      # See <http://strugglers.net/~andy/blog/2011/09/04/linux-ipv6-router-advertisements-and-forwarding/>.
      "net.ipv6.conf.all.accept_ra" = lib.mkOverride 99 2;
      "net.ipv6.conf.default.accept_ra" = lib.mkOverride 99 2;

      # Forward IPv6 packets.
      "net.ipv6.conf.all.forwarding" = lib.mkOverride 99 true;
      "net.ipv6.conf.default.forwarding" = lib.mkOverride 99 true;
    };
  };

  networking = {
    useDHCP = false;

    interfaces.uplink0 = {
      ipv4 = {
        addresses = lib.singleton {
          address = "188.253.26.208";
          prefixLength = 24;
        };
      };
      ipv6 = {
        addresses = lib.singleton {
          address = "2a0c:16c2:500:663:216:3cff:fe63:bdc6";
          prefixLength = 48;
        };
      };
    };

    defaultGateway = {
      address = "188.253.26.1";
      interface = "uplink0";
    };

    defaultGateway6 = {
      address = "2a0c:16c2:500::1";
      interface = "uplink0";
    };

    nameservers = [
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
    ];
  };

  services.ddclient.usev6 = lib.mkForce "cmdv6, cmdv6=\"'${lib.getExe pkgs.getv6addresses}' -p -x | tr '\\n' ',' | sed 's/,*$//'\"";
}
