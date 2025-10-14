{
  lib,
  pkgs,
  ...
}:
{
  systemd.user.services.hyprland-startup-sound = {
    Install.WantedBy = [ "hyprland-session.target" ];
    Unit = {
      Description = "Hyprland startup sound";
      After = [
        "hyprland-session.target"
        "wireplumber.service"
      ];
      Requires = [ "wireplumber.service" ];
    };

    Service = {
      Type = "oneshot";
      Restart = "no";
      ExecStart = ''${lib.getExe' pkgs.pipewire "pw-cat"} --media-role Notification --volume 1.00 -p "${pkgs.kdePackages.oxygen-sounds}/share/sounds/Oxygen-Sys-Log-In-Long.ogg"'';
    };
  };
}
