{
  config,
  flakeRoot,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  uplinkMACAddress = "00:16:3c:63:bd:c6";
in
{
  networking.useDHCP = false;

  boot = {
    initrd.services.udev.rules = ''
      SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplinkMACAddress}", NAME="uplink"
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

  services.ddclient.usev6 = lib.mkForce "cmdv6, cmdv6=\"'${lib.getExe pkgs.getv6addresses}' -p -x | tr '\\n' ',' | sed 's/,*$//'\"";
}
