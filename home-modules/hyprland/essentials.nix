{
  pkgs,
  lib,
  config,
  ...
}@args:
let
  cfg = config.wayland.windowManager.hyprland;
in
{
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    home.packages = with pkgs; [
      wl-clipboard
      grim
      slurp
      swappy
      wayvnc
      soteria
      brightnessctl
    ];

    programs.wayprompt = {
      enable = true;
      settings.general.corner-radius = 0;
    };

    services = {
      cliphist.enable = true;
      swaync.enable = true;
      playerctld.enable = true;
      blueman-applet.enable =
        if (builtins.hasAttr "osConfig" args) then
          (builtins.getAttr "osConfig" args).services.blueman.enable
        else
          false;
      gpg-agent.pinentry.package = config.programs.wayprompt.package;
      udiskie = {
        enable = true;
        notify = true;
        tray = "always";
        automount = lib.mkDefault false;
      };
    };
  };
}
