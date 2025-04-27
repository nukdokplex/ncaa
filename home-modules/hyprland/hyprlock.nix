{ lib, config, ... }:
let
  cfg = config.wayland.windowManager.hyprland;
in
{
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };
      };
    };
  };
}
