{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.hypridle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock --immediate --no-fade-in";
      };
      listener =
        with config.wm-settings.idleTimeouts;
        lib.optional (dimBacklight > -1) {
          timeout = dimBacklight;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        ++ lib.optional (offBacklight > -1) {
          timeout = offBacklight;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        ++ lib.optional (sessionLock > -1) {
          timeout = sessionLock;
          on-timeout = "loginctl lock-session";
        }
        ++ lib.optional (systemSuspend > -1) {
          timeout = systemSuspend;
          on-timeout = "systemctl suspend";
        };
    };
  };
}
