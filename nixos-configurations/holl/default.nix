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
      common-base
      sing-box-client
      netbird-client
      syncthing
      nukdokplex
    ]);

  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTU6xRGIBdqjKFfxdHMQw2XuuB769eMJ8N4zBsOuEtp root@holl";

  users.users.nukdokplex.extraGroups = [ "acme" ];

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.nukdokplex.openssh.authorizedKeys.keys;
}
