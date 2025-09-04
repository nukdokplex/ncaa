{
  networking.nftables.firewall.zones.trusted.interfaces = [
    "uplink0"
    "uplink1"
  ];

  networking.interfaces.uplink0.wakeOnLan.enable = true;
  networking.interfaces.uplink1.wakeOnLan.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="d8:43:ae:95:44:e7", NAME="uplink0"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="d8:43:ae:95:44:e8", NAME="uplink1"
  '';

}
