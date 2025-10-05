{ lib, ... }:
{
  programs.hyprland.enable = true;

  home-manager.sharedModules = lib.singleton (
    { lib, ... }:
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
      wayland.windowManager.hyprland = {
        settings = {
          monitor = [
            "desc:LG Electronics LG FHD 405TOFJ1Z803,           1920x1080@100.00, 0x0,    1.00"
            "desc:Xiaomi Corporation P24FBA-RAGL 5438300034300, 1920x1080@100.00, 1920x0, 1.00" # <-- main
          ];
          workspace =
            builtins.genList (
              x:
              let
                ws = x + 1;
                monitor =
                  if ws > 10 then
                    "desc:LG Electronics LG FHD 405TOFJ1Z803"
                  else
                    "desc:Xiaomi Corporation P24FBA-RAGL 5438300034300";
              in
              "${toString ws}, persistent:true, monitor:${monitor}"
            ) 20
            |> (
              a:
              a
              ++ [

              ]
            )
            |> lib.mkBefore;
        };
      };
    }
  );
}
