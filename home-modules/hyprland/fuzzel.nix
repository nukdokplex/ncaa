{ config, lib, ... }:
let
  cfg = config.wayland.windowManager.hyprland;
in
{
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    programs.fuzzel = {
      enable = true;
      settings = {
        border = {
          width = 3;
          radius = 0;
        };
      };
    };
  };
}
