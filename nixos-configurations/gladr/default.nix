{ pkgs, ezModules, ... }: {
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./stylix.nix
    ./secrets
    ./power.nix
    ./printing.nix
    ./network.nix
    ezModules.my-common-desktop
  ];

  common = {
    base.enable = true;
    desktop.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.rocmSupport = true; # AMDGPU support for packages
  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.05";
  hardware.enableAllFirmware = true;

  home-manager.sharedModules =
    let
      timeouts = {
        dim_backlight = 45;
        off_backlight = 90;
        lock = 180;
        suspend = 600;
      };
    in
    [{
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
        swayidle-timeouts = timeouts;
      };
      wayland.windowManager.hyprland = {
        settings.monitor = [
          "desc:LG Display 0x05F6, 1920x1080, 0x0, 1.25"
        ];
        usesBattery = true;
        beEnergyEfficient = true;
        hypridle-timeouts = timeouts;
      };
    }];

  hardware.bluetooth.enable = true;
}
