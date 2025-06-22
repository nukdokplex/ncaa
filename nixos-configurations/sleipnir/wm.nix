{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
    package = pkgs.sway;
    wrapperFeatures.gtk = true;
  };

  security.pam.services.swaylock = { };

  programs.hyprland = {
    enable = true;
  };

  security.pam.services.hyprlock = { };

  home-manager.sharedModules = [
    (
      { ezModules, ... }:
      {
        imports = [
          ezModules.sway
          ezModules.hyprland
        ];

        wm-settings = {
          idleTimeouts = {
            dimBacklight = -1;
            offBacklight = 300;
            sessionLock = 360;
            systemSuspend = 3600;
          };
        };

        wayland.windowManager.hyprland = {
          settings = {
            monitor = [
              "desc:LG Electronics LG ULTRAWIDE 0x00000459, 2560x1080@60.00000, 0x0, 1.00"
            ];
          };
        };

        wayland.windowManager.sway = {
          config = {
            output."LG Electronics LG ULTRAWIDE 0x00000459" = {
              mode = "2560x1080@60Hz";
              scale = "1.0";
            };
          };
        };
      }
    )
  ];
}
