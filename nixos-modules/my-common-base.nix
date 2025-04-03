{ lib, config, ezModules, ... }: {
  imports = [
    ezModules.secrets
  ];
  i18n.defaultLocale = "ru_RU.UTF-8";
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
}
