{
  config,
  lib,
  pkgs,
  ...
}:
let
  flakePath = "path:${lib.escapeShellArg "${config.home.homeDirectory}/ncaa"}";
in
{
  programs = {
    direnv.enable = true;
    nix-index.enable = true;
    oh-my-posh = {
      enable = true;
      useTheme = "kushal";
    };

    zsh = {
      enable = true;

      initContent = lib.mkBefore ''
        ZSH_TMUX_AUTOSTART=true

        # disable tmux autostart when ssh client is connected
        if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
          ZSH_TMUX_AUTOSTART=false
        fi
      '';

      sessionVariables = {
        ZSH_TMUX_AUTOCONNECT = "true";
        ZSH_TMUX_AUTOQUIT = "false";
      };

      shellAliases = {
        nrs = "sudo nixos-rebuild --flake ${flakePath}#$('${lib.getExe' pkgs.nettools "hostname"}') --accept-flake-config switch";
        nrt = "sudo nixos-rebuild --flake ${flakePath}#$('${lib.getExe' pkgs.nettools "hostname"}') --accept-flake-config test";
        nrb = "sudo nixos-rebuild --flake ${flakePath}#$('${lib.getExe' pkgs.nettools "hostname"}') --accept-flake-config boot";
        nrbuild = "nixos-rebuild --flake  ${flakePath}#$('${lib.getExe' pkgs.nettools "hostname"}') --accept-flake-config build";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "tmux" ];
      };
    };
  };
}
