let
  uplinkMACAddress = "c8:ff:bf:05:82:fc";
  uplink2MACAddress = "c8:ff:bf:05:82:fd";
in
{
  networking.nftables.firewall.rules.nixos-firewall.from = [
    "uplink"
    "nb-nukdokplex"
  ];

  boot.initrd.services.udev.rules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplinkMACAddress}", NAME="uplink"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplink2MACAddress}", NAME="uplink2"
  '';

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplinkMACAddress}", NAME="uplink"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplink2MACAddress}", NAME="uplink2"
  '';

  systemd.network = {
    enable = true;
    networks.home = {
      enable = true;
      matchConfig.Name = "uplink";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      dhcpV4Config = {
        UseDNS = true;
        UseRoutes = true;
      };
    };
  };

  services.fail2ban = {
    enable = true;
    banaction = "nftables-multiport";
    banaction-allports = "nftables-allports";
  };
}
