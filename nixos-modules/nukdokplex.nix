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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5+elt9Z1Nwj6unJsK6UJNH3Ly2+oUxjRUuPtn7u6Th cardno:FFFE_0643DA9F"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP6J3TsIrfH96FYltcB56y2mACg3P5JMDK0ZDDI33NBo cardno:FFFE_775BC6BC"
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
