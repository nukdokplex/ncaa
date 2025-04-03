{ pkgs, ezModules, ... }: {
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./stylix.nix
    ./secrets
    ./printing.nix
    ./tssp.nix
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

  networking.firewall.interfaces.enp42s0 = {
    allowedUDPPorts = [ 22000 ];
    allowedTCPPorts = [ 22000 ];
  };
  networking.interfaces.enp42s0.wakeOnLan.enable = true;

  home-manager = {
    sharedModules = let
      timeouts = {
        off_backlight = 300;
        lock = 360;
        suspend = 3600;
      };
    in [{
      wayland.windowManager.hyprland = {
        settings = {
          monitor = [
            "desc:LG Electronics LG ULTRAWIDE 0x00000459, 2560x1080@60.00000, 0x0, 1.00"
          ];
        };
        hypridle-timeouts = timeouts;
      };
      wayland.windowManager.sway = {
        config = {
          output."LG Electronics LG ULTRAWIDE 0x00000459" = {
            mode = "2560x1080@60Hz";
            scale = "1.0";
          };
        };
        swayidle-timeouts = timeouts;
      };
    }];
  };

  programs.optical-disk-essentials.enable = true; 
  programs.k3b-custom.enable = true;

  programs.sway.package = pkgs.swayfx;
  hardware.bluetooth.enable = true;

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
