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
  xdg.configFile."waybar/hyprland" = {
    source = jsonFormat.generate "waybar-config-hyprland.json" ([
      config.programs.waybar.settings.hyprland-bar
    ]);
  };

  systemd.user.services.waybar-hyprland = {
    Unit = {
      Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
      Documentation = "https://github.com/Alexays/Waybar/wiki";
      PartOf = [ "hyprland-session.target" ];
      After = [ "hyprland-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
      X-Restart-Triggers = [
        "${config.xdg.configFile."waybar/hyprland".source}"
        "${config.xdg.configFile."waybar/style.css".source}"
      ];
    };

    Service = {
      Environment = lib.optional config.programs.waybar.systemd.enableInspect "GTK_DEBUG=interactive";
      ExecReload = "'${lib.getExe' pkgs.coreutils "kill"}' -SIGUSR2 $MAINPID";
      ExecStart = "'${lib.getExe config.programs.waybar.package}' -c \"${
        config.xdg.configFile."waybar/hyprland".target
      }\" ${lib.optionalString config.programs.waybar.systemd.enableDebug " -l debug"}";
      KillMode = "mixed";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "hyprland-session.target" ];
  };

  imports = [
    ezModules.waybar
  ];
}
