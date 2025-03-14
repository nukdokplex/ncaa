{ pkgs, lib, config, ... }: let
  cfg = config.services.blueman;
in {
  options.services.blueman.enableApplet = lib.mkEnableOption "blueman-applet systemd user session service";
  config = lib.mkIf (cfg.enable && cfg.enableApplet) {
    systemd.user.services.blueman-applet = {
      description = "Blueman applet";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "'${lib.getExe' pkgs.blueman "blueman-applet"}'";
    };
  };
}
