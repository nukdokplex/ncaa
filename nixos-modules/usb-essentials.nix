{ pkgs, lib, config, ... }: {
  options.programs.usb-essentials.enable = lib.mkEnableOption "set of essential programs for usb";
  config = lib.mkIf config.programs.usb-essentials.enable {
    environment.systemPackages = with pkgs; [
      usbutils
      usb-modeswitch
      usb-modeswitch-data
    ];
    
    hardware.usb-modeswitch.enable = lib.mkDefault true;
  };
}
