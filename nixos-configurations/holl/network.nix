let
  uplink0MACAddress = "c8:ff:bf:05:82:fc";
  uplink1MACAddress = "c8:ff:bf:05:82:fd";
in
{
  boot.initrd.services.udev.rules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplink0MACAddress}", NAME="uplink0"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplink1MACAddress}", NAME="uplink1"
  '';

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplink0MACAddress}", NAME="uplink0"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${uplink1MACAddress}", NAME="uplink1"
  '';

  networking.useDHCP = true;
  networking.useNetworkd = true;

  systemd.network = {
    enable = true;
    networks.home = {
      enable = true;
      matchConfig.Name = "uplink0";
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
