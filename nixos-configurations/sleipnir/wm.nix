{ pkgs, lib, ... }:
{
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  programs.hyprland.enable = true;
  programs.niri.enable = true;

  home-manager.sharedModules = lib.singleton ({
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
  });
}
