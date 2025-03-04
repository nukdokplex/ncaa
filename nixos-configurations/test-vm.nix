{ pkgs, lib, ... }: {
  common.base.enable = true;
  common.desktop.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "ru_RU.UTF-8";

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 4;
    };
  };

  users.users.nukdokplex = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$8dRfprNnDsvSuKjFAwV8x.$yeNqUhW6gmYYuFSOEf4bKbmk6IUwYjN9kQPxRsp/fe4";
    extraGroups = [ "wheel" "input" "networkmanager" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    users.nukdokplex.wayland.windowManager.hyprland = {
      enable = true;
      enableCustomConfiguration = true;
    };
  };

  programs.hyprland = {
    enable = true;
  };

  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/5d/wallhaven-5dl1g7.jpg";
      hash = "sha256-w9x5FzjFGZy75fYwuKHM0pi+Sda2bP4KY8fWpP/nVFY=";
    };
    base16Scheme = {
      system = "base16";
      name = "Apathy modified";
      author = "Jannik Siebert (https://github.com/janniks)";
      variant = "dark";
      palette = {
        base00 = "#031A16";
        base01 = "#0B342D";
        base02 = "#184E45";
        base03 = "#2B685E";
        base04 = "#5F9C92";
        base05 = "#81B5AC";
        base06 = "#A7CEC8";
        base07 = "#D2E7E4";
        base08 = "#3E9688";
        base09 = "#3E7996";
        base0A = "#3E4C96";
        base0B = "#883E96";
        base0C = "#963E4C";
        base0D = "#4C963E";
        base0E = "#96883E";
        base0F = "#3E965B";
      };
    };
  };
}
