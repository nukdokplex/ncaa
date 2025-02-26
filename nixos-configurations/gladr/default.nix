{ pkgs, ... }: {
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./stylix.nix
    ./secrets
  ];

  common = {
    base.enable = true;
    desktop.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.rocmSupport = true; # AMDGPU support for packages
  time.timeZone = "Asia/Yekaterinburg";
  i18n.defaultLocale = "ru_RU.UTF-8";
  system.stateVersion = "25.05";
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;

  users.users.nukdokplex = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$8dRfprNnDsvSuKjFAwV8x.$yeNqUhW6gmYYuFSOEf4bKbmk6IUwYjN9kQPxRsp/fe4";
    extraGroups = [ "wheel" "input" "networkmanager" ];
  };

  home-manager = {
    sharedModules = [{
      wayland.windowManager.hyprland.settings.monitor = [
        "desc:LG Display 0x05F6, 1920x1080, 0x0, 1.25"
      ];
    }];
    users.nukdokplex = {
      wayland.windowManager.hyprland = {
        enable = true;
        usesBattery = true;
        beEnergyEfficient = true;
        enableCustomConfiguration = true;
        hypridle-timeouts = {
          dim_backlight = 45;
          off_backlight = 90;
          lock = 180;
          suspend = 600;
        };
      };
    };
  };

  programs.hyprland.enable = true;
  security.pam.services.hyprlock = {};
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };
  services.tumbler.enable = true;

  programs.steam = {
    enable = true;
    enableCustomConfiguration = true;
  };

  programs.lutris = {
    enable = true;
    enableCustomConfiguration = true;
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  programs.via.enable = true;
}
