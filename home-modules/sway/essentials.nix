{ pkgs, lib, config, ... }@args: let
  cfg = config.wayland.windowManager.sway;
in {
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    home.packages = with pkgs; [
      wl-clipboard
      grim
      slurp
      wayvnc
      soteria
      brightnessctl
    ];

    services = {
      cliphist.enable = true;
      swaync.enable = true;
      playerctld.enable = true;
      blueman-applet.enable = if (builtins.hasAttr "osConfig" args) then (builtins.getAttr "osConfig" args).services.blueman.enable else false; 
      gpg-agent.pinentryPackage = pkgs.wayprompt;
      udiskie = {
        enable = true;
        notify = true;
        tray = "always";
      };
    };
  };
}
