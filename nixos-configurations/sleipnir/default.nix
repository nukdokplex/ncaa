{
  pkgs,
  ezModules,
  inputs,
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
    ++ [
      ezModules.common-desktop
      ezModules.email-passwords
      ezModules.dyndns
      ezModules.sing-box-client
      ezModules.syncthing
    ];

  nixpkgs.localSystem.system = "x86_64-linux";
  nixpkgs.config.rocmSupport = true; # AMDGPU support for packages
  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.05";
  hardware.enableAllFirmware = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDrS2sugOWzdcYzL7PfkMHbhfWwReIJOyB7wo5qNcSW root@sleipnir";

  networking.interfaces.enp42s0.wakeOnLan.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;

  home-manager.sharedModules = [
    {
      programs.gaming-essentials.enable = true;
    }
  ];

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
