{
  pkgs,
  lib,
  lib',
  ezModules,
  config,
  inputs,
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

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDo2pi5x42hS1jbB9gHvMfr3iiDWr4Mpe5CPNhpddIGH root@gladr";

  hardware.bluetooth.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;

  stylix = {
    image = pkgs.fetchurl {
      urls = [
        "https://w.wallhaven.cc/full/9m/wallhaven-9m59md.png"
        "https://web.archive.org/web/https://w.wallhaven.cc/full/9m/wallhaven-9m59md.png"
      ];
      sha256 = "0r2v8q70zljp26lz2mphdrhs0q1gj63idk8znb1mzipqzqadzl3y";
    };
    polarity = "dark";
  };
}
