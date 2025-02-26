{ lib, config, ... }: let
  cfg = config.wayland.windowManager.hyprland;
in {
  wayland.windowManager.hyprland = {
    programs.terminal = lib.getExe config.programs.wezterm.package;
    settings = {
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:ctrl_space_toggle,compose:ralt";
      };

      bindd = [
        "$mainMod, U, Run browser, exec, '${cfg.programs.webBrowser}'"
        "$mainMod, Return, Run terminal, exec, '${cfg.programs.terminal}'"
      ];

      exec-once = lib.mkAfter [
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] ayugram-desktop"
        "[workspace 2 silent] vesktop"
        "[workspace 4 silent] '${cfg.programs.fileManager}'" 
        "[workspace 5 silent] thunderbird"
        "[workspace 7 silent] keepassxc"
        "[workspace 10 silent] spotify"
      ];

      windowrulev2 = lib.mkAfter [
        "worspace 2 silent, class:vesktop"
      ];
    };
  };
}
