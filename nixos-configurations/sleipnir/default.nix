{ pkgs, inputs, ... }: {
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
  hardware.enableAllFirmware = true;

  networking.firewall.interfaces.enp42s0 = {
    allowedUDPPorts = [ 22000 ];
    allowedTCPPorts = [ 22000 ];
  };

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

  networking.interfaces.enp42s0.wakeOnLan.enable = true;

  users.users.nukdokplex = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$8dRfprNnDsvSuKjFAwV8x.$yeNqUhW6gmYYuFSOEf4bKbmk6IUwYjN9kQPxRsp/fe4";
    extraGroups = [ "wheel" "input" "networkmanager" ];
  };

  home-manager = {
    sharedModules = [{
      wayland.windowManager.hyprland.settings.monitor = [
        "desc:LG Electronics LG ULTRAWIDE 0x00000459, 2560x1080@60.00000, 0x0, 1.00"
      ];
    }];
    users.nukdokplex = {
      programs.gaming-essentials.enable = true;
      services.ollama = {
        enable = true;
        acceleration = "rocm";
      };
      wayland.windowManager.hyprland = {
        enable = true;
        enableCustomConfiguration = true;
        hypridle-timeouts = {
          off_backlight = 300;
          lock = 360;
          suspend = 3600;
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

  services.printing.drivers = [
    pkgs.nur.repos.nukdokplex.epson_201310w
  ];
  hardware.printers.ensurePrinters = [{
    name = "Epson_L120_Series";
    location = "Home";
    deviceUri = "usb://EPSON/L120%20Series?serial=544E594B3132383744";
    model = "EPSON_L120.ppd";
  }];

  programs.via.enable = true;

  services.turing-smart-screen-python = {
    enable = true; 
    systemd.enable = true;
    fonts = with inputs.tssp.packages.${pkgs.system}.resources.fonts; [
      geforce
      generale-mono
      jetbrains-mono
      racespace
      roboto
      roboto-mono
    ];
    themes = with inputs.tssp.packages.${pkgs.system}.resources.themes; [
      LandscapeEarth
      Landscape6Grid
    ];
    settings = {
      config = {
        COM_PORT = "AUTO";
        THEME = "Landscape6Grid";
        HW_SENSORS = "PYTHON";
        ETH = "enp42s0";
        WLO = "enp5s0";
        CPU_FAN = "AUTO";
      };
      display = {
        REVISION = "A";
        BRIGHTNESS = 20;
        DISPLAY_REVERSE = false;
      };
    };
  };


  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };
}
