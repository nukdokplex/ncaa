{ ... }: {
  common.base.enable = true;
  common.desktop.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "ru_RU.UTF-8";

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };

  users.users.nukdokplex = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$8dRfprNnDsvSuKjFAwV8x.$yeNqUhW6gmYYuFSOEf4bKbmk6IUwYjN9kQPxRsp/fe4";
    extraGroups = [ "wheel" "input" "networkmanager" ];
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 4;
    };
  };
}
