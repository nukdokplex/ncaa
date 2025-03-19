{ lib, pkgs, config, osConfig, ... }: {
  imports = [
    ./desktop.nix
    ./hyprland.nix
    ./nixvim
    ./ranger.nix
    ./secrets
    ./sway.nix
    ./xdg-dirs.nix
  ];
  common.enable = true;
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
