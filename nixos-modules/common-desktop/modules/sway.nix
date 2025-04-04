{ lib, config, ... }: {
  home-manager.users.nukdokplex = {
    wayland.windowManager.sway = {
      enable = true;
      enableCustomConfiguration = true;
    };
    programs.gaming-essentials.enable = true;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.pam.services.swaylock = {};
  programs.nm-applet.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;
}
