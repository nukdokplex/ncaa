{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    usbutils
    usb-modeswitch
    usb-modeswitch-data
  ];
  hardware.usb-modeswitch.enable = lib.mkDefault true;
}
