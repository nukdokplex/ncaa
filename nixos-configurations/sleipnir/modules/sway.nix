{
  lib,
  pkgs,
  config,
  ...
}:
{
  home-manager.sharedModules = [
    {
      wayland.windowManager.sway = {
        config = {
          output."LG Electronics LG ULTRAWIDE 0x00000459" = {
            mode = "2560x1080@60Hz";
            scale = "1.0";
          };
        };
        swayidle-timeouts = {
          off_backlight = 300;
          lock = 360;
          suspend = 3600;
        };
      };
    }
  ];

  home-manager.users.nukdokplex = {
    wayland.windowManager.sway = {
      enable = true;
      enableCustomConfiguration = true;
    };
  };

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  security.pam.services.swaylock = { };
  programs.nm-applet.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;
}
