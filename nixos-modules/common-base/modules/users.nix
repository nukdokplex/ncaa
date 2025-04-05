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

    hashedPasswordFile = config.age.secrets.nukdokplex-password.path;
  };
  age.secrets.nukdokplex-password.rekeyFile = flakeRoot + /secrets/generated/common/nukdokplex-password.age; 
}
