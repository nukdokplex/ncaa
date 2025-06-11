{
  lib,
  config,
  pkgs,
  ezModules,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };
in
{
  xdg.configFile."waybar/sway" = {
    source = jsonFormat.generate "waybar-config-sway.json" ([
      config.programs.waybar.settings.sway-bar
    ]);
  };

  systemd.user.services.waybar-sway = {
    Unit = {
      Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
      Documentation = "https://github.com/Alexays/Waybar/wiki";
      PartOf = [ "sway-session.target" ];
      After = [ "sway-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
      X-Restart-Triggers = [
        "${config.xdg.configFile."waybar/sway".source}"
        "${config.xdg.configFile."waybar/style.css".source}"
      ];
    };

    Service = {
      Environment = lib.optional config.programs.waybar.systemd.enableInspect "GTK_DEBUG=interactive";
      ExecReload = "'${lib.getExe' pkgs.coreutils "kill"}' -SIGUSR2 $MAINPID";
      ExecStart = "'${lib.getExe config.programs.waybar.package}' -c \"${
        config.xdg.configFile."waybar/sway".target
      }\" ${lib.optionalString config.programs.waybar.systemd.enableDebug " -l debug"}";
      KillMode = "mixed";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "sway-session.target" ];
  };

  imports = [
    ezModules.waybar
  ];
}
