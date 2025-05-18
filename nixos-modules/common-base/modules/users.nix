{
  flakeRoot,
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.zsh.enable = true;
  users = lib.fix (users: {
    defaultUserShell = pkgs.zsh;
    mutableUsers = true;

    users.nukdokplex = {
      name = "nukdokplex";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "input"
        "networkmanager"
        "adbusers"
        "cdrom"
        "podman"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGatzKUrvt0471LtM+558AKJRVEJMK3qQL9P/DCoE/X0 nukdokplex"
      ];

      hashedPasswordFile = config.age.secrets.nukdokplex-hashed-password.path;
    };

    users.root.openssh.authorizedKeys.keys = users.users.nukdokplex.openssh.authorizedKeys.keys;
  });

  age.secrets.nukdokplex-hashed-password.rekeyFile =
    flakeRoot + /secrets/non-generated/common/nukdokplex-hashed-password.age;
}
