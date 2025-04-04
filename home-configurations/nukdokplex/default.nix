{ lib, pkgs, config, ezModules, ... }: {
  imports = [
    ./desktop.nix
    ./firefox.nix
    ./hyprland.nix
    ./nixvim
    ./ranger.nix
    ./secrets
    ./sway.nix
    ./xdg-dirs.nix
    ezModules.common
  ];
  home = {
    username = "nukdokplex";
    stateVersion = "25.05";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.git = {
    userName = "nukdokplex";
    userEmail = "nukdokplex@nukdokplex.ru";
  };
}
