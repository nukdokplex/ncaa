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
      path = ./modules;
      recursive = false;
    }
    ++ [
      ezModules.common-desktop
      ezModules.email-passwords
      ezModules.dyndns
      ezModules.sing-box-client
    ];

  nixpkgs.hostPlatform = "x86_64-linux";
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
}
