{
  pkgs,
  lib,
  config,
  ...
}@args:
let
  cfg = config.wayland.windowManager.hyprland;
  systemd =
    if (builtins.hasAttr "osConfig" args) then
      (builtins.getAttr "osConfig" args).systemd.package
    else
      pkgs.systemd;
in
{
  options.wayland.windowManager.hyprland.hypridle-timeouts =
    let
      mkTimeoutOption =
        name:
        lib.mkOption {
          default = -1;
          description = "Time in seconds to trigger ${name} timeout";
        };
    in
    {
      dim_backlight = mkTimeoutOption "dim backlight";
      off_backlight = mkTimeoutOption "off backlight";
      lock = mkTimeoutOption "session lock";
      suspend = mkTimeoutOption "suspend";
    };

  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "'${lib.getExe' cfg.package "hyprctl"}' dispatch dpms on";
          before_sleep_cmd = "'${lib.getExe' systemd "loginctl"}' lock-session";
          ignore_dbus_inhibit = false;
          lock_cmd = "'${lib.getExe config.programs.hyprlock.package}' --immediate --no-fade-in";
        };
        listener =
          with cfg.hypridle-timeouts;
          [ ]
          ++ lib.optional (dim_backlight > -1) {
            timeout = dim_backlight;
            on-timeout = "'${lib.getExe pkgs.brightnessctl}' -s set 10";
            on-resume = "'${lib.getExe pkgs.brightnessctl}' -r";
          }
          ++ lib.optional (off_backlight > -1) {
            timeout = off_backlight;
            on-timeout = "'${lib.getExe' cfg.package "hyprctl"}' dispatch dpms off";
            on-resume = "'${lib.getExe' cfg.package "hyprctl"}' dispatch dpms on";
          }
          ++ lib.optional (lock > -1) {
            timeout = lock;
            on-timeout = "'${lib.getExe' systemd "loginctl"}' lock-session";
          }
          ++ lib.optional (suspend > -1) {
            timeout = suspend;
            on-timeout = "'${lib.getExe' systemd "systemctl"}' suspend";
          };
      };
    };
  };
}
