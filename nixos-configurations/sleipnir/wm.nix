{ lib, ... }:
{
  programs.hyprland.enable = true;

  home-manager.sharedModules = lib.singleton (
    { ... }:
    {
      wm-settings = {
        idleTimeouts = {
          dimBacklight = -1;
          offBacklight = 300;
          sessionLock = 360;
          systemSuspend = 3600;
        };
      };

      programs.waybar.settings = {
        # boo, waybar can't handle output descriptions
        horizontalBar = {
          output = [ "HDMI-A-1" ];
        };

        verticalBar = {
          output = [ "DP-1" ];
          position = lib.mkForce "left";
          margin = lib.mkForce "10 0 10 10";
        };
      };

      # output settings are managed with nwg-displays now
      wayland.windowManager = {
        hyprland.settings = {
          monitorv2 = [
            {
              output = "HDMI-A-1";
              mode = "1920x1080@100.00";
              position = "0x0";
              scale = "1.00";
              transform = 1;
            }
            {
              output = "DP-1";
              mode = "1920x1080@100.00";
              position = "1080x420";
              scale = "1.00";
            }
          ];

          general = {
            allow_tearing = true;
          };
        };
      };
    }
  );

  home-manager.users.nukdokplex.wayland.windowManager = {
    hyprland.settings = {
      workspace = lib.mkForce [
        "1,  persistent:true, monitor:DP-1,     defaultName:coding,    default:true"
        "2,  persistent:true, monitor:DP-1,     defaultName:files                  "
        "3,  persistent:true, monitor:DP-1,     defaultName:email                  "
        "4,  persistent:true, monitor:DP-1,     defaultName:gaming                 "
        "5,  persistent:true, monitor:DP-1,     defaultName:video                  "
        "6,  persistent:true, monitor:HDMI-A-1, defaultName:browsing,  default:true"
        "7,  persistent:true, monitor:HDMI-A-1, defaultName:messaging              "
        "8,  persistent:true, monitor:HDMI-A-1, defaultName:password               "
        "9,  persistent:true, monitor:HDMI-A-1, defaultName:reserved               "
        "10, persistent:true, monitor:HDMI-A-1, defaultName:music                  "
      ];
    };
  };
}
