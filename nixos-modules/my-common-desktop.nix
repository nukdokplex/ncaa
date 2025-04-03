{ lib, config, ezModules, ... }: {
  imports = [
    ezModules.my-common-base
  ];

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
  security.pam.services.hyprlock = {};

  programs.nm-applet.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;

  programs.steam = {
    enable = true;
    enableCustomConfiguration = true;
  };

  programs.lutris = {
    enable = true;
    enableCustomConfiguration = true;
  };

  programs.via.enable = true;

  virtualisation.podman.enable = true;

  services.yggdrasil = {
    enable = true;
    settings = {
      MulticastInterfaces = [
        {
          Regex = "enp42s0";
          Beacon = true;
          Listen = true;
        }
      ];
    };
  };
}
