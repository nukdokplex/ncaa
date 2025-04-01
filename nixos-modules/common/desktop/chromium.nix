{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.common.desktop.enable {
    programs.chromium = {
      enable = true;
      initialPrefs = {

      };
    };
  };
}
