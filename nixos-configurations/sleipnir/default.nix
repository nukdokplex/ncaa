{ pkgs, lib, config, ... }: {
  imports = [
    ./disko.nix
    ./stylix.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "Asia/Yekaterinburg";
  i18n.defaultLocale = "ru_RU.UTF-8";
  system.stateVersion = "25.05";

  boot = {
    initrd = {
      enable = true;
      includeDefaultModules = true;
      network.enable = true;
      kernelModules = [ "amdgpu" ]; # because i want make correct modeset early
    };
    kernelModules = [ "kvm-amd" "amdgpu" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        efiSupport = true;
        useOSProber = true;
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S4EVNZFN703254E";
      };
    };
  };

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
