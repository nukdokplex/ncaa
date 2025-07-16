{
  pkgs,
  ezModules,
  lib',
  lib,
  config,
  ...
}:
{
  imports =
    lib'.umport {
      path = ./.;
      exclude = [ ./default.nix ];
      recursive = false;
    }
    ++ (with ezModules; [
      common-desktop
      email-passwords
      dyndns
      acme
      sing-box-client
      syncthing
      gaming
    ]);

  nixpkgs.localSystem.system = "x86_64-linux";
  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.05";
  hardware.enableAllFirmware = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDrS2sugOWzdcYzL7PfkMHbhfWwReIJOyB7wo5qNcSW root@sleipnir";

  networking.interfaces.enp42s0.wakeOnLan.enable = true;

  boot.initrd.services.udev.rules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="d8:43:ae:95:44:e7", NAME="uplink25"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="d8:43:ae:95:44:e8", NAME="uplink1"
  '';

  hardware.bluetooth.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;

  home-manager.sharedModules = [
    {
      programs.gaming-essentials.enable = true;
    }
  ];

  home-manager.users.nukdokplex = {
    services.ollama = {
      enable = true;
      acceleration = "rocm";
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

  stylix = {
    image = pkgs.fetchurl {
      urls = [
        "https://w.wallhaven.cc/full/57/wallhaven-57loy5.jpg"
        "https://web.archive.org/web/https://w.wallhaven.cc/full/57/wallhaven-57loy5.jpg"
      ];
      sha256 = "187734kcjslgijlqsc9dc58vbx25ibmnr1q58313q2s9na1z782c";
    };
    polarity = "dark";
  };
}
