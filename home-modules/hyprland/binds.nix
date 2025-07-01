{
  pkgs,
  lib,
  lib',
  config,
  inputs,
  ...
}:
let
  wm-utils = lib.getExe pkgs.wm-utils;
  tts-custom = lib.getExe pkgs.tts-custom;
in
{
  wayland.windowManager.hyprland.settings = {
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

    bindd =
      [
        # menus
        "Control_L Alt_L, Delete, Open power menu, exec, '${wm-utils}' fuzzel_power_menu"
        "$mainMod, V, Open clipboard history, exec, '${lib.getExe config.services.cliphist.package}' list | '${lib.getExe config.programs.fuzzel.package}' --dmenu -p 'Select clipboard history entry...' | '${lib.getExe config.services.cliphist.package}' decode | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'"
        "$mainMod, D, Run drun menu, exec, '${lib.getExe config.programs.fuzzel.package}' --show-actions"

        # screenshots
        "$mainMod, P, Screenshot screen region, exec, '${wm-utils}' screenshot_region"
        "$mainMod Shift_L, P, Screenshot active output, exec, '${wm-utils}' screenshot_output"

        # Text-to-speech
        "$mainMod, T, Text-to-speech (russian), exec, '${wm-utils}' tts ru"
        "$mainMod Shift_L, T, Text-to-speech (english), exec, '${wm-utils}' tts en"

        # submaps
        "$mainMod, Insert, Enable passthrough mode (disable all binds except this one to disable), submap, passthrough"

        # applications
        "$mainMod, O, Open file manager, exec, ${config.wm-settings.defaultApplications.fileManager}"
        "$mainMod, U, Run browser, exec, '${lib.getExe config.wm-settings.defaultApplications.webBrowser}'"
        "$mainMod, Return, Run terminal, exec, '${lib.getExe config.wm-settings.defaultApplications.terminal}'"

        # windows manipulation
        "$mainMod Shift_L, Q, Close active window, killactive"
        "$mainMod, F, Toggle window fullscreen, fullscreen"
        "$mainMod Shift_L, F, Toggle fake fullscreen, fullscreenstate, 0 3"
        "$mainMod Shift_L, Space, Toggle window floating, togglefloating"
        "$mainMod, B, Toggle focus between tiles and floating layers, hy3:togglefocuslayer"

        # layout stuff
        "$mainMod, comma, Split horizontally, hy3:makegroup, h, toggle, ephemeral"
        "$mainMod, period, Split vertically, hy3:makegroup, v, toggle, ephemeral"
        "$mainMod Shift, comma, Change group layout to horizontal, hy3:changegroup, h"
        "$mainMod Shift, period, Change group layout to vertical, hy3:changegroup, v"
        "$mainMod, semicolon, Make tab, hy3:makegroup, tab, toggle, ephemeral"
        "$mainMod Shift, semicolon, Change group layout to tabbed, hy3:changegroup, toggletab"

        # misc
        "$mainMod, Grave, Expo, hyprexpo:expo, toggle"
      ]
      ++ lib.flatten (
        lib'.withDirections (
          { xkbNoPrefix, hyprland, ... }:
          let
            inherit (hyprland) direction;
          in
          [
            # move focus
            "$mainMod, ${xkbNoPrefix.arrow}, Move focus ${direction}, hy3:movefocus, ${direction}, warp"
            "$mainMod, ${xkbNoPrefix.hjkl}, Move focus ${direction}, hy3:movefocus, ${direction}, warp"

            # move window
            "$mainMod Shift_L, ${xkbNoPrefix.arrow}, Swap window ${direction}, hy3:movewindow, ${direction}"
            "$mainMod Shift_L, ${xkbNoPrefix.hjkl}, Swap window ${direction}, hy3:movewindow, ${direction}"

          ]
        )
      )
      ++ lib.flatten (
        lib'.withNumbers (
          { xkbNoPrefix, number, ... }:
          [
            # focus workspace
            "$mainMod, ${xkbNoPrefix.digit}, Switch to workspace ${toString number}, workspace, ${builtins.toString number}"
            "$mainMod Alt_L, ${xkbNoPrefix.digit}, Switch to workspace ${toString (10 + number)}, workspace, ${toString (10 + number)}"

            # move window to workspace
            "$mainMod Shift_L, ${xkbNoPrefix.digit}, Move active window to workspace ${toString number}, hy3:movetoworkspace, ${toString number}, follow, warp"
            "$mainMod Shift_L Alt_L, ${xkbNoPrefix.digit}, Move window to workspace ${toString (10 + number)}, hy3:movetoworkspace, ${toString (10 + number)}, follow, warp"
          ]
        )
      );

    bindde = lib.flatten (
      lib'.withDirections (
        {
          xkbNoPrefix,
          direction,
          resizeVector,
          ...
        }:
        [
          # resize window
          "$mainMod Control_L, ${xkbNoPrefix.arrow}, Resize window with arrows, resizeactive, ${toString (resizeVector.x * 60)} ${toString (resizeVector.y * 60)}"
          "$mainMod Control_L, ${xkbNoPrefix.hjkl}, Resize window with vim keys, resizeactive, ${toString (resizeVector.x * 60)} ${toString (resizeVector.y * 60)}"
        ]
      )
    );

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
      ", XF86AudioMute, Mute default sink, exec, '${wm-utils}' sound_output_toggle"
      ", XF86AudioPlay, Toggle play/pause for playback, exec, '${lib.getExe pkgs.playerctl}' play-pause"
      ", XF86AudioPrev, Previous media in playlist, exec, '${lib.getExe pkgs.playerctl}' previous"
      ", XF86AudioNext, Next media in playlist, exec, '${lib.getExe pkgs.playerctl}' next"
      "$mainMod, M, Toggle mute for default audio sink, exec, '${wm-utils}' toggle_sound_mute @DEFAULT_SINK@"
      "$mainMod Shift_L, M, Toggle mute for default audio source, exec, NONBLOCKING_NOTIFY=true '${wm-utils}' toggle_sound_mute @DEFAULT_SOURCE@"
    ];
  };

}
