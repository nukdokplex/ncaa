{ lib, pkgs, config, ... }: {
  imports = [
    ./nixvim
    ./hyprland.nix
    ./xdg-dirs.nix
  ];
  common.enable = true;
  home = {
    username = "nukdokplex";
    stateVersion = "25.05";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
    packages = with pkgs; [
      vesktop
      telegram-desktop
      keepassxc
      qbittorrent
      vlc
      tor-browser
      chromium
      thunderbird
    ];
  };

  programs.spicetify = {
    enable = true;
    enableCustomConfiguration = true;
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        window_background_opacity = 0.75
      }
    '';
  };

  programs.git = {
    userName = "nukdokplex";
    userEmail = "nukdokplex@nukdokplex.ru";
  };

  services.syncthing = {
    enable = true;
    tray = true;
  };
}
