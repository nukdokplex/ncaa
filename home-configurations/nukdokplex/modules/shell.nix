{ config, lib, pkgs, ... }: let
  flakePath = "path:${lib.escapeShellArg "${config.home.homeDirectory}/ncaa"}";
  hostName = "$('${lib.getExe' pkgs.nettools "hostname"}')";
in {
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "kushal";
  };

  programs.nix-index = {
    enable = true;
  };
  
  programs.zsh = {
    enable = true;

    shellAliases = {
      nrs = "sudo nixos-rebuild --flake ${flakePath}#${hostName} --accept-flake-config switch";
      nrt = "sudo nixos-rebuild --flake ${flakePath}#${hostName} --accept-flake-config test";
      nrb = "sudo nixos-rebuild --flake ${flakePath}#${hostName} --accept-flake-config boot";
      nrbuild = "nixos-rebuild --flake ${flakePath}#${hostName} --accept-flake-config build";
      agenix-rekey = "nix develop .#agenix-rekey";
    };

    oh-my-zsh = {
      enable = true;
    };
  };
}
