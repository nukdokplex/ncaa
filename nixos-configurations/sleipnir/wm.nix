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
        horizontalBar.output = [ "HDMI-A-1" ];
        verticalBar.output = [ "DP-1" ];
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
    hyprland.settings =
      let
        primary = "desc:Xiaomi Corporation P24FBA-RAGL 5438300034300";
        secondary = "desc:LG Electronics LG FHD 405TOFJ1Z803";
      in
      {
        workspace = lib.mkForce [
          "1,  persistent:true, monitor:${primary},   defaultName:coding, default:true"
          "2,  persistent:true, monitor:${primary},   defaultName:files"
          "3,  persistent:true, monitor:${primary},   defaultName:email"
          "4,  persistent:true, monitor:${primary},   defaultName:gaming"
          "5,  persistent:true, monitor:${primary},   defaultName:video"
          "6,  persistent:true, monitor:${secondary}, defaultName:browsing, default:true"
          "7,  persistent:true, monitor:${secondary}, defaultName:messaging"
          "8,  persistent:true, monitor:${secondary}, defaultName:password"
          "9,  persistent:true, monitor:${secondary}, defaultName:reserved"
          "10, persistent:true, monitor:${secondary}, defaultName:music"
        ];
      };
  };
}
