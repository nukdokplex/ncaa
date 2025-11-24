{
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
      desktop
      wm
      email-passwords
      dyndns
      acme
      sing-box-client
      syncthing
      gaming
      netbird-client
      nukdokplex
      russian-locale
      epson-l120-shared-printer
      nixvim
      dev-utils
      flatpak
    ]);

  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.05";
  hardware.enableAllFirmware = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDo2pi5x42hS1jbB9gHvMfr3iiDWr4Mpe5CPNhpddIGH root@gladr";

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.nukdokplex.openssh.authorizedKeys.keys;
}
