{
  lib,
  lib',
  ezModules,
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
  nixpkgs.config.rocmSupport = true; # AMDGPU support for packages
  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.05";
  hardware.enableAllFirmware = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDo2pi5x42hS1jbB9gHvMfr3iiDWr4Mpe5CPNhpddIGH root@gladr";

  hardware.bluetooth.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;
}
