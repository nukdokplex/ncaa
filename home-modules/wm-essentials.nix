args@{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./wm-quirks
  ];

  home.packages = with pkgs; [
    wl-clipboard
    grim
    slurp
    swappy
    wayvnc
    soteria
    brightnessctl
    wm-utils
  ];

  programs.wayprompt = {
    enable = true;
    settings.general.corner-radius = 0;
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      border = {
        width = 3;
        radius = 0;
      };
    };
  };

  programs.nemo.enable = true;
  programs.file-roller.enable = true;

  services.wpaperd.enable = true;
  services.cliphist.enable = true;
  services.swaync.enable = true;
  services.playerctld.enable = true;
  services.blueman-applet.enable = lib.mkDefault (args.osConfig.services.blueman.enable or false);
  services.network-manager-applet.enable = lib.mkDefault (
    args.osConfig.networking.networkmanager.enable or false
  );
  services.gpg-agent.pinentry.package = config.programs.wayprompt.package;
  services.udiskie = {
    enable = true;
    notify = true;
    tray = "always";
    automount = lib.mkDefault false;
  };
}
