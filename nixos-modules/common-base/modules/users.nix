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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFX3BPaOblXcbg/frl0PtdJdHp008Pt7N3qqe82+GOSW (none)"
      ];

      hashedPasswordFile = config.age.secrets.nukdokplex-password.path;
    };

    users.root.openssh.authorizedKeys.keys = users.users.nukdokplex.openssh.authorizedKeys.keys;
  });

  age.secrets.nukdokplex-hashed-password.rekeyFile =
    flakeRoot + /secrets/common/nukdokplex-hashed-password.age;
}
