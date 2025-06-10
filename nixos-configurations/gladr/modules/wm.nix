{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
  };

  security.pam.services.hyprlock = { };

  programs.sway = {
    enable = true;
    package = pkgs.sway;
    wrapperFeatures.gtk = true;
  };

  security.pam.services.swaylock = { };

  home-manager.sharedModules = [
    (
      { ezModules, ... }:
      {
        imports = [
          ezModules.hyprland
          ezModules.sway
        ];

        wm-settings = {
          deviceUsesBattery = true;
          beEnergyEfficient = true;
          idleTimeouts = {
            dimBacklight = 30;
            offBacklight = 300;
            sessionLock = 310;
            systemSuspend = 1800;
          };
        };

        wayland.windowManager.hyprland = {
          settings.monitor = [
            "desc:LG Display 0x05F6, 1920x1080, 0x0, 1.25"
          ];
        };

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
        };
      }
    )
  ];
}
