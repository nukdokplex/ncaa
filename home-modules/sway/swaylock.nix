{ lib, config, ... }: let
  cfg = config.wayland.windowManager.sway;
in {
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    programs.swaylock = {
      enable = true;
      settings = {
        show-keyboard-layout = true;
        show-failed-attempts = true;
      };
    };
  };
}
