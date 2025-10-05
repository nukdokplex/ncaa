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

      # output settings are managed with nwg-displays now
      wayland.windowManager = {
        hyprland.settings = {
          monitor = [
            "desc:LG Electronics LG FHD 405TOFJ1Z803,           1920x1080@100.00, 0x0,    1.00"
            "desc:Xiaomi Corporation P24FBA-RAGL 5438300034300, 1920x1080@100.00, 1920x0, 1.00" # <-- main
          ];
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
