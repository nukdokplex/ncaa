{ lib, pkgs, config, ... }: {
  home-manager.sharedModules = [{
    wayland.windowManager.hyprland = {
      settings = {
        monitor = [
          "desc:LG Electronics LG ULTRAWIDE 0x00000459, 2560x1080@60.00000, 0x0, 1.00"
        ];
      };
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
