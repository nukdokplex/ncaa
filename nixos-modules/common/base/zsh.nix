{ pkgs, config, lib, ... }: {
  config = lib.mkIf config.common.base.enable {
    programs.zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        theme = "agnoster";
      };
    };
    users.defaultUserShell = pkgs.zsh;
  };
}
