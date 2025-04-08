{ flakeRoot, config, ... }: {
  users.mutableUsers = true;
  users.users.nukdokplex = {
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

  age.secrets.nukdokplex-password.rekeyFile = flakeRoot + /secrets/generated/common/nukdokplex-password.age; 
}
