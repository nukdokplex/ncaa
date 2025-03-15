{ pkgs, lib, config, ... }: let
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
    };
  };
}
