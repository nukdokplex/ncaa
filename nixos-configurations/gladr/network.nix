{
  services.udev.extraRules = ''
    KERNEL=="wlan*", ATTR{address}=="80:30:49:1c:2c:6f", NAME="uplink2"
  '';
}
