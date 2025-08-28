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
      common-base
      acme
      sing-box-client
      netbird-client
    ]);

  nixpkgs.localSystem.system = "x86_64-linux";
  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.11";
  hardware.enableAllFirmware = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTU6xRGIBdqjKFfxdHMQw2XuuB769eMJ8N4zBsOuEtp root@holl";

  hardware.bluetooth.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;

  users.users.nukdokplex.extraGroups = [ "acme" ];
}
