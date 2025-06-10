args@{
  lib,
  config,
  pkgs,
  ...
}:
{
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

  services = {
    cliphist.enable = true;
    swaync.enable = true;
    playerctld.enable = true;
    blueman-applet.enable = lib.mkDefault (
      lib.attrByPath [ "osConfig" "services" "blueman" "enable" ] false args
    );
    nm-applet.enable = lib.mkDefault (
      lib.attrByPath [ "osConfig" "networking" "networkmanager" "enable" ] true args
    );
    gpg-agent.pinentry.package = config.programs.wayprompt.package;
    udiskie = {
      enable = true;
      notify = true;
      tray = "always";
      automount = lib.mkDefault false;
    };
  };
}
