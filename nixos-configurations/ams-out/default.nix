{ pkgs, inputs, flakeRoot, modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix") # adds some kernel modules which are required to deal with virtio devices
    ./boot.nix
    ./filesystems.nix
    ./network.nix
    ./secrets
  ];

  common.base.enable = true;
  services.qemuGuest.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "ru_RU.UTF-8";
  system.stateVersion = "25.05";

  users.users.nukdokplex = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$8dRfprNnDsvSuKjFAwV8x.$yeNqUhW6gmYYuFSOEf4bKbmk6IUwYjN9kQPxRsp/fe4";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = import (flakeRoot + /home-configurations/nukdokplex/ssh-keys.nix);
  };
  
  nix.settings.trusted-users = [ "nukdokplex" ];
}
