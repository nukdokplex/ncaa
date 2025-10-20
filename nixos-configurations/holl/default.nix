{
  lib',
  ezModules,
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
      syncthing
      nukdokplex
    ]);

  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTU6xRGIBdqjKFfxdHMQw2XuuB769eMJ8N4zBsOuEtp root@holl";

  users.users.nukdokplex.extraGroups = [ "acme" ];

  user.users.root.openssh.authorizedKeys.keyFiles = [
    /etc/ssh/authorized_keys.d/nukdokplex
  ];
}
