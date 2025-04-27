{ pkgs, lib, config, inputs, ... }@args:
let
  cfg = config.wayland.windowManager.hyprland;
  wm-utils = "'${lib.getExe inputs.self.packages.${pkgs.system}.wm-utils}'";
in
{
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    wayland.windowManager.hyprland.settings = with inputs.self.lib.hyprland-utils; {
      # bind flags:
      # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
      # r -> release, will trigger on release of a key.
      # c -> click, will trigger on release of a key or button as long as the mouse cursor stays inside input:drag_threshold.
      # g -> drag, will trigger on release of a key or button as long as the mouse cursor moves outside input:drag_threshold.
      # o -> longPress, will trigger on long press of a key.
      # e -> repeat, will repeat when held.
      # n -> non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
      # m -> mouse, see below.
      # t -> transparent, cannot be shadowed by other binds.
      # i -> ignore mods, will ignore modifiers.
      # s -> separate, will arbitrarily combine keys between each mod/key, see [Keysym combos](#keysym-combos) above.
      # d -> has description, will allow you to write a description for your bind.
      # p -> bypasses the app's requests to inhibit keybinds.

      bindd = [
        "Control_L Alt_L, Delete, Open power menu, exec, ${wm-utils} fuzzel_power_menu"
        "$mainMod, P, Screenshot screen region, exec, ${wm-utils} screenshot_region"
        "$mainMod Shift_L, P, Screenshot active output, exec, ${wm-utils} screenshot_output"
        "$mainMod, T, Open clipboard history, exec, '${lib.getExe config.services.cliphist.package}' list | '${lib.getExe config.programs.fuzzel.package}' --dmenu -p 'Select clipboard history entry...' | '${lib.getExe config.services.cliphist.package}' decode | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'"
        "$mainMod, Insert, Enable passthrough mode (disable all binds except this one to disable), submap, passthrough"
        "$mainMod, O, Open file manager, exec, '${cfg.programs.fileManager}'"
        "$mainMod Shift_L, Q, Close active window, killactive"
        "$mainMod, Z, Toggle split (top/side) of the current window, togglesplit"
        "$mainMod, F, Toggle window fullscreen, fullscreen"
        "$mainMod Shift_L, F, Toggle fake fullscreen, fullscreenstate, 0 3"
        "$mainMod Shift_L, Space, Toggle window floating, togglefloating"
        "$mainMod, D, Run drun menu, exec, '${lib.getExe config.programs.fuzzel.package}' --show-actions"
        "$mainMod, Grave, Expo, hyprexpo:expo, toggle"
      ]
      ++ generateDirectionBinds 60 ({ key, direction, ... }: "$mainMod, ${key}, Move focus, movefocus, ${direction}")
      ++ generateDirectionBinds 60 ({ key, direction, ... }: "$mainMod Shift_L, ${key}, Move window around, swapwindow, ${direction}")
      ++ generateWorkspaceBinds (i: key: "$mainMod, ${key}, Switch to workspace ${builtins.toString i}, workspace, ${builtins.toString i}")
      ++ generateWorkspaceBinds (i: key: "$mainMod Alt_L, ${key}, Switch to workspace ${builtins.toString (10+i)}, workspace, ${builtins.toString (10+i)}")
      ++ generateWorkspaceBinds (i: key: "$mainMod Shift_L, ${key}, Move active window to workspace ${builtins.toString i}, movetoworkspace, ${builtins.toString i}")
      ++ generateWorkspaceBinds (i: key: "$mainMod Shift_L Alt_L, ${key}, Move window to workspace ${builtins.toString (10+i)}, movetoworkspace, ${builtins.toString (10+i)}");

      bindde = with inputs.self.lib.hyprland-utils; [ ]
        ++ generateDirectionBinds 60 ({ key, resizeX, resizeY, ... }: "$mainMod Control_L, ${key}, Resize window, resizeactive, ${builtins.toString resizeX} ${builtins.toString resizeY}");

      binddm = [
        "$mainMod, mouse:272, Move window, movewindow"
        "$mainMod, mouse:273, Resize window, resizewindow"
      ];

      binddel = [
        ", XF86AudioRaiseVolume, Increase volume for default sink, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, Decrease volume for default sink, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessDown, Decrease screen brightness, exec, '${lib.getExe pkgs.brightnessctl}' set 10%-"
        ", XF86MonBrightnessUp, Increase screen brightness, exec, '${lib.getExe pkgs.brightnessctl}' set 10%+"
      ];

      binddl = [
        ", XF86AudioMute, Mute default sink, exec, ${wm-utils} sound_output_toggle"
        ", XF86AudioPlay, Toggle play/pause for playback, exec, '${lib.getExe pkgs.playerctl}' play-pause"
        ", XF86AudioPrev, Previous media in playlist, exec, '${lib.getExe pkgs.playerctl}' previous"
        ", XF86AudioNext, Next media in playlist, exec, '${lib.getExe pkgs.playerctl}' next"
        "$mainMod, M, Toggle mute for default audio sink, exec, ${wm-utils} toggle_sound_mute @DEFAULT_SINK@"
        "$mainMod Shift_L, M, Toggle mute for default audio source, exec, ${wm-utils} toggle_sound_mute @DEFAULT_SOURCE@"
      ];
    };
  };
}
