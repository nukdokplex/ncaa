{
  flakeRoot,
  config,
  pkgs,
  ...
}:
{
  programs.zsh.enable = true;
  users = {
    users.nukdokplex = {
      name = "nukdokplex";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
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
      ];

      hashedPasswordFile = config.age.secrets.nukdokplex-hashed-password.path;
    };
  };

  age.secrets.nukdokplex-hashed-password.rekeyFile =
    flakeRoot + /secrets/non-generated/common/nukdokplex-hashed-password.age;
}
