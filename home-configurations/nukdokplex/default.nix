{ lib, pkgs, config, ... }: {
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
      libreoffic-fresh
      tor-browser
      chromium
      thunderbird
    ];
  };

  programs.spicetify = {
    enable = true;
    enableCustomConfiguration = true;
  };

  programs.git = {
    userName = "nukdokplex";
    userEmail = "nukdokplex@nukdokplex.ru";
  };
}
