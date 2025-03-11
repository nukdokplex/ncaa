{ pkgs, lib, config, ... }: let
  cfg = config.common;
in {
  options.common.enable = lib.mkEnableOption "common modules";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable  = true;
      signing.format = "openpgp";
    };
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
    programs.zsh = {
      enable = true;
      shellAliases = {
        nrs = "sudo nixos-rebuild switch --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname) --accept-flake-config";
        nrb = "sudo nixos-rebuild boot --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname) --accept-flake-config";
        nrt = "sudo nixos-rebuild test --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname) --accept-flake-config";
        nrbuild = "sudo nixos-rebuild build --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname) --accept-flake-config";
      };

      oh-my-zsh = {
        enable = true;
        theme = "agnoster";
      };
    };
    stylix.iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme.override { color = "adwaita"; };
      light = "Papirus";
      dark = "Papirus-Dark";
    };

    # this config causes adding unwanted nixpkgs overlay
    stylix.targets.gnome-text-editor.enable = false;
  };
}
