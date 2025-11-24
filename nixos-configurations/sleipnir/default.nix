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
      nukdokplex

      desktop
      wm
      email-passwords
      dyndns
      acme
      sing-box-client
      syncthing
      gaming
      netbird-client
      optical-disks
      russian-locale
      #      epson-l120-shared-printer
      nixvim
      dev-utils
    ]);

  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ3AiuAxEAsxhsMKRXIaSKe10hi608O7UJ3vZzZdtfDB root@sleipnir";

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

  systemd.services.sing-box.wantedBy = lib.mkForce [ ];

  nix.gc.automatic = lib.mkForce false;
}
