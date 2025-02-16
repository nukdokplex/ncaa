{ lib, config, ... }: {
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "us,ru";
      kb_options = "grp:ctrl_space_toggle,compose:ralt";
    };

    bindd = [
      "$mainMod, U, Run browser, exec, firefox"
      "$mainMod, Return, Run terminal, exec, '${lib.getExe config.programs.wezterm.package}'"
    ];

    exec-once = lib.mkAfter [
      "[workspace 1 silent] firefox"
      "[workspace 2 silent] telegram-desktop"
      "[workspace 2 silent] vesktop"
      "[workspace 5 silent] thunderbird"
      "[workspace 7 silent] keepassxc"
      "[workspace 10 silent] spotify"
    ];
  };
}
