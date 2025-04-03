{ config, pkgs, lib, ... }: {
  config = lib.mkIf config.common.desktop.enable {
    programs.usb-essentials.enable = true;
    programs.adb.enable = true;
  };
}
