{ pkgs, ... }:
{
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  environment.systemPackages = with pkgs; [
    glib # provides gio
    scrcpy
    cachix
  ];

  programs.usb-essentials.enable = true;
  programs.adb.enable = true;
  programs.via.enable = true;
}
