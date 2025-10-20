{
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
      netbird-client
      optical-disks
      nukdokplex
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

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.nukdokplex.openssh.authorizedKeys.keys;

  users.users.nukdokplex.extraGroups = [
    "video"
    "render"
  ];
}
