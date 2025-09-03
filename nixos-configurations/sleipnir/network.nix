{
  networking.nftables.firewall.rules.nixos-firewall.from = [ "uplink*" ];

  networking.interfaces.uplink0.wakeOnLan.enable = true;
  networking.interfaces.uplink1.wakeOnLan.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="d8:43:ae:95:44:e7", NAME="uplink0"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="d8:43:ae:95:44:e8", NAME="uplink1"
  '';

}
