{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.swayidle = {
    enable = true;
    systemdTarget = "sway-session.target";
    events = [
      {
        event = "before-sleep";
        command = "loginctl lock-session; '${lib.getExe pkgs.playerctl}' pause";
      }
      {
        event = "lock";
        command = "'${lib.getExe config.programs.swaylock.package}' -f";
      }
      {
        event = "unlock";
        command = "'${lib.getExe' pkgs.coreutils "kill"}' -USR1 $('${lib.getExe' pkgs.procps "pgrep"}' -f swaylock)";
      }
    ];
    timeouts =
      with config.wm-settings.idleTimeouts;
      lib.optional (dimBacklight > -1) {
        timeout = dimBacklight;
        command = "'${lib.getExe pkgs.brightnessctl}' -s set 10";
        resumeCommand = "'${lib.getExe pkgs.brightnessctl}' -r";
      }
      ++ lib.optional (offBacklight > -1) {
        timeout = offBacklight;
        command = "swaymsg 'output * dpms off'";
        resumeCommand = "swaymsg 'output * dpms on'";
      }
      ++ lib.optional (sessionLock > -1) {
        timeout = sessionLock;
        command = "loginctl lock-session";
      }
      ++ lib.optional (systemSuspend > -1) {
        timeout = systemSuspend;
        command = "systemctl suspend";
      };
  };
}
