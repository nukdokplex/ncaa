{ lib, pkgs, config, ... }: {
  home-manager.sharedModules = [{
    wayland.windowManager.hyprland = {
      settings.monitor = [
        "desc:LG Display 0x05F6, 1920x1080, 0x0, 1.25"
      ];
      usesBattery = true;
      beEnergyEfficient = true;
      hypridle-timeouts = {
        off_backlight = 300;
        lock = 360;
        suspend = 3600;
      };
    };
  }];

  home-manager.users.nukdokplex = {
    wayland.windowManager.hyprland = {
      enable = true;
      enableCustomConfiguration = true;
    };
  };

  programs.hyprland = {
    enable = true;
  };

  security.pam.services.hyprlock = {};
  programs.nm-applet.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;
  
}
