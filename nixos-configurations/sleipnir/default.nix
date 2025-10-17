{
  ezModules,
  lib',
  lib,
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
      netbird-client
      optical-disks
    ]);

  system.autoUpgrade.enable = false;

  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDrS2sugOWzdcYzL7PfkMHbhfWwReIJOyB7wo5qNcSW root@sleipnir";

  home-manager.sharedModules = lib.singleton {
    programs.gaming-essentials.enable = true;
  };

  home-manager.users.nukdokplex.services.ollama = {
    enable = false;
    acceleration = "rocm";
  };

  users.users.nukdokplex.extraGroups = [
    "video"
    "render"
  ];
}
