{ pkgs, lib, config, osConfig, ... }: let
  cfg = config.wayland.windowManager.sway;
in {
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    home.packages = with pkgs; [
      wl-clipboard
      grim
      slurp
      wayvnc
      soteria
    ];

    services = {
      cliphist.enable = true;
      swaync.enable = true;
      playerctld.enable = true;
      blueman-applet.enable =  osConfig.services.blueman.enable;
    };
  };
}
