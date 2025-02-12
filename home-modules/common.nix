{ pkgs, lib, config, ... }: let
  cfg = config.common;
in {
  options.common.enable = lib.mkEnableOption "common modules";

  config = lib.mkIf cfg.enable {
    programs.git.enable = true;
    programs.gpg.enable = true;
    programs.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
    programs.zsh = {
      enable = true;
      shellAliasess = {
        nrs = "sudo nixos-rebuild switch --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname)";
        nrb = "sudo nixos-rebuild boot --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname)";
        nrt = "sudo nixos-rebuild test --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname)";
        nrbuild = "sudo nixos-rebuild build --flake path:$HOME/ncaa#$(hostnamectl --json=short | '${lib.getExe pkgs.jq}' --raw-output .Hostname)";
      };

      oh-my-zsh = {
        enable = true;
        theme = "agnoster";
      };
    };
  };
}
