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
      syncthing
      gaming
      nukdokplex
      russian-locale
      # epson-l120-shared-printer
      nixvim
      dev-utils
      media-utils
      flatpak
    ]);

  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.11";
  hardware.enableAllFirmware = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqKHrMB4PQ0EVN7H3S6GJI8ETNJvzStR/WNIFV74Kl/ root@gladr";

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.nukdokplex.openssh.authorizedKeys.keys;
}
