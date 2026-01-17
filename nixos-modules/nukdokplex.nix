{
  flakeRoot,
  config,
  pkgs,
  ...
}:
{
  programs.zsh.enable = true;
  users = {
    groups.nukdokplex.gid = 1000;
    users.nukdokplex = {
      uid = 1000;
      name = "nukdokplex";
      group = "nukdokplex";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "users"
        "wheel"
        "input"
        "networkmanager"
        "adbusers"
        "cdrom"
        "podman"
        "netbird-nukdokplex"
      ];
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIG45VPuEV1NcMvY2BNjjhMZGMTMuGB7vDs2K7oDnbEGpAAAACHNzaDphdXRo nukdokplex@nukdokplex.ru" # 2362853
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIO8j+Xj/XrGrZxtpoS54xgxIQJ0LzlRcgf65XbS2Gs72AAAACHNzaDphdXRo nukdokplex@nukdokplex.ru" # 32050569
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnEZ1Grox7sfgwKzr5TKF2ogVW+yc58Nd3LfB4P3JmY nukdokplex@nukdokplex.ru"
      ];

      hashedPasswordFile = config.age.secrets.nukdokplex-user-password-hashed.path;
    };
  };

  age.secrets = {
    nukdokplex-user-password = {
      intermediary = true;
      rekeyFile = flakeRoot + /secrets/non-generated/common/nukdokplex-user-password.age;
    };
    nukdokplex-user-password-hashed = {
      rekeyFile = flakeRoot + /secrets/generated/common/nukdokplex-user-password-hashed.age;
      generator = {
        dependencies.password = config.age.secrets.nukdokplex-user-password;
        script = "sha512-hashed-password";
      };
    };
  };
}
