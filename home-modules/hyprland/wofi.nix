{ pkgs, lib, config, ... }: let
  cfg = config.wayland.windowManager.hyprland;
in {
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    programs.wofi = {
      enable = true;
    };
    xdg.configFile."wofi-power-menu.toml" = {
      enable = true;
      target = "wofi-power-menu.toml";
      source = (pkgs.formats.toml { }).generate "wofi-power-menu.toml" {
        menu = {
          shutdown = {
            enabled = "true";
            title = "Power off";
            cmd = "systemctl poweroff";
          };

          reboot = {
            enabled = "true";
            title = "Reboot";
            cmd = "systemctl reboot";
          };

          suspend = {
            enabled = "true";
            title = "Suspend";
            cmd = "systemctl suspend";
          };

          hibernate = {
            enabled = "true";
            title = "Hibernate";
            cmd = "systemctl hibernate";
          };

          logout = {
            enabled = "true";
            title = "Logout";
            cmd = "hyprctl dispatch exit";
          };

          lock-screen = {
            enabled = "true";
            title = "Lock";
            cmd = "loginctl lock-session";
          };
        };
      };
    };
  };
}
