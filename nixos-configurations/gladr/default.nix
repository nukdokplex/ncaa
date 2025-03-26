{ pkgs, ... }: {
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./stylix.nix
    ./secrets
    ./power.nix
    ./printing.nix
    ./network.nix
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
  hardware.enableAllFirmware = true;

  users.users.nukdokplex = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$8dRfprNnDsvSuKjFAwV8x.$yeNqUhW6gmYYuFSOEf4bKbmk6IUwYjN9kQPxRsp/fe4";
    extraGroups = [ "wheel" "input" "networkmanager" ];
  };

  home-manager = {
    sharedModules = let
      timeouts = {
        dim_backlight = 45;
        off_backlight = 90;
        lock = 180;
        suspend = 600;
      };
    in [{
      wayland.windowManager.sway =  {
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
    users.nukdokplex = {
      programs.gaming-essentials.enable = true;
      wayland.windowManager.sway = {
        enable = true;
        enableCustomConfiguration = true;
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.pam.services.swaylock = {};
  security.pam.services.hyprlock = {};

  programs.nm-applet.enable = true;
  services.blueman.enable = true;

  services.tumbler.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

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

  programs.via.enable = true;

  virtualisation.podman.enable = true;
}
