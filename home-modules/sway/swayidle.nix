{ pkgs, lib, config, ... }: let
  cfg = config.wayland.windowManager.sway;
in {
  options.wayland.windowManager.sway.swayidle-timeouts = let
    mkTimeoutOption = name: lib.mkOption {
      default = -1;
      description = "Time in seconds to trigger ${name} timeout";
    };
  in {
    dim_backlight = mkTimeoutOption "dim backlight";
    off_backlight = mkTimeoutOption "off backlight";
    lock = mkTimeoutOption "session lock";
    suspend = mkTimeoutOption "suspend";
  };

  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "loginctl lock-session"; }
        { event = "before-sleep"; command = "'${lib.getExe pkgs.playerctl}' pause"; }
        { event = "lock"; command = "swaylock -f"; }
        { event = "unlock"; command = "kill -USR1 $(pgrep -f swaylock)"; }
      ];
      timeouts = with cfg.swayidle-timeouts;
        lib.optional (dim_backlight > -1) { 
          timeout = dim_backlight; 
          command = "'${lib.getExe pkgs.brightnessctl}' -s set 10"; 
        } ++
        lib.optional (off_backlight > -1) { 
          timeout = off_backlight; 
          command = "swaymsg 'output * dpms off'"; 
          resumeCommand = "swaymsg 'output * dmps on'"; 
        } ++
        lib.optional (lock > -1) { 
          timeout = lock; 
          command = "loginctl lock-session"; 
        } ++
        lib.optional (suspend > -1) { 
          timeout = suspend; 
          command = "systemctl suspend"; 
        };
    };
  };
}
