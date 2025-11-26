{
  lib',
  ezModules,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports =
    lib'.umport {
      path = ./.;
      exclude = [ ./default.nix ];
      recursive = true;
    }
    ++ (with ezModules; [
      base-system
      sing-box-client
      netbird-client
      syncthing
      nukdokplex
      russian-locale
    ]);

  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTU6xRGIBdqjKFfxdHMQw2XuuB769eMJ8N4zBsOuEtp root@holl";

  users.users.nukdokplex.extraGroups = [ "acme" ];

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.nukdokplex.openssh.authorizedKeys.keys;

  systemd.services.sing-box.wantedBy = lib.mkForce [ ];

  environment.systemPackages = with pkgs; [
    unflac # used to unpack image+.cue music releases
  ];
}
