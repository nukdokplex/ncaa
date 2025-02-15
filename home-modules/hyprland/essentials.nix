{ pkgs, lib, config, ... }: let
  cfg = config.wayland.windowManager.hyprland;
in {
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    home.packages = with pkgs; [
      wl-clipboard
    ];
    services = {
      cliphist.enable = true;
      swaync.enable = true;
    };
  };
}
