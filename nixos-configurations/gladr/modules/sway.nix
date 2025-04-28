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
          output."LG Display 0x05F6 Unknown" = {
            mode = "1920x1080@60Hz";
            scale = "1.25";
          };
          input."1739:52545:SYN1B7F:00_06CB:CD41_Touchpad" = {
            natural_scroll = "enabled";
            dwt = "enabled";
            tap = "enabled";
            drag_lock = "enabled";
            click_method = "button_areas";
          };
        };
        usesBattery = true;
        beEnergyEfficient = true;
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
    wrapperFeatures.gtk = true;
  };

  security.pam.services.swaylock = { };
  programs.nm-applet.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;
}
