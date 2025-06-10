{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nm-applet;
in
{
  options.services.nm-applet = {
    enable = lib.mkEnableOption "nm-applet, a NetworkManager control applet for GNOME";

    indicator = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to use indicator instead of status icon.
        It is needed for Appindicator environments, like Enlightenment.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.nm-applet = {
      Unit = {
        Description = "Network Manager applet";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "'${lib.getExe pkgs.networkmanagerapplet}' ${lib.optionalString cfg.indicator "--indicator"}";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    dbus.packages = [ pkgs.gcr ];
  };
}
