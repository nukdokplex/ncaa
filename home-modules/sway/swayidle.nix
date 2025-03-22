{ pkgs, lib, config, ... }@args: let
  cfg = config.wayland.windowManager.sway;
  systemd = if (builtins.hasAttr "osConfig" args) then (builtins.getAttr "osConfig" args).systemd.package else pkgs.systemd;
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
        { event = "before-sleep"; command = "'${lib.getExe' systemd "loginctl"}' lock-session"; }
        { event = "before-sleep"; command = "'${lib.getExe pkgs.playerctl}' pause"; }
        { event = "lock"; command = "'${lib.getExe config.programs.swaylock.package}' -f"; }
        { event = "unlock"; command = "'${lib.getExe' pkgs.coreutils "kill"}' -USR1 $('${lib.getExe' pkgs.procps "pgrep"}' -f swaylock)"; }
      ];
      timeouts = with cfg.swayidle-timeouts;
        lib.optional (dim_backlight > -1) { 
          timeout = dim_backlight; 
          command = "'${lib.getExe pkgs.brightnessctl}' -s set 10"; 
          resumeCommand = "'${lib.getExe pkgs.brightnessctl}' -r";
        } ++
        lib.optional (off_backlight > -1) { 
          timeout = off_backlight; 
          command = "'${lib.getExe' cfg.package "swaymsg"}' 'output * dpms off'"; 
          resumeCommand = "'${lib.getExe' cfg.package "swaymsg"}' 'output * dmps on'"; 
        } ++
        lib.optional (lock > -1) { 
          timeout = lock; 
          command = "'${lib.getExe' systemd "loginctl"}' lock-session"; 
        } ++
        lib.optional (suspend > -1) { 
          timeout = suspend; 
          command = "'${lib.getExe systemd "systemctl"}' suspend"; 
        };
    };
  };
}
