{
  pkgs,
  lib,
  lib',
  config,
  ...
}:
let
  wm-utils = lib.getExe pkgs.wm-utils;
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
        "Control Alt, Delete, Open power menu, exec, '${wm-utils}' fuzzel_power_menu"
        "$mainMod, V, Open clipboard history, exec, '${lib.getExe config.services.cliphist.package}' list | '${lib.getExe config.programs.fuzzel.package}' --dmenu -p 'Select clipboard history entry...' | '${lib.getExe config.services.cliphist.package}' decode | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'"
        "$mainMod, D, Run drun menu, exec, '${lib.getExe config.programs.fuzzel.package}' --show-actions"

        # screenshots
        "$mainMod, P, Screenshot screen region, exec, '${wm-utils}' screenshot_region"
        "$mainMod Shift, P, Screenshot active output, exec, '${wm-utils}' screenshot_output"

        # OCR narrator
        "$mainMod, T, Text-to-speech (russian), exec, '${wm-utils}' ocr_narrator ru"
        "$mainMod Shift, T, Text-to-speech (english), exec, '${wm-utils}' ocr_narrator en"

        # OCR copy
        "$mainMod, C, OCR screenshot copy (russian), exec, '${wm-utils}' ocr_copy ru"
        "$mainMod Shift, C, OCR screenshot copy (english), exec, '${wm-utils}' ocr_copy en"

        # submaps
        "$mainMod, Insert, Enable passthrough mode (disable all binds except this one to disable), submap, passthrough"

        # applications
        "$mainMod, O, Open file manager, exec, ${config.wm-settings.defaultApplications.fileManager}"
        "$mainMod, U, Run browser, exec, '${lib.getExe config.wm-settings.defaultApplications.webBrowser}'"
        "$mainMod, Return, Run terminal, exec, '${lib.getExe config.wm-settings.defaultApplications.terminal}'"

        # windows manipulation
        "$mainMod Shift, Q, Close active window, killactive"
        "$mainMod, F, Toggle window fullscreen, fullscreen"
        "$mainMod Shift, F, Toggle fake fullscreen, fullscreenstate, 0 3"
        "$mainMod Shift, Space, Toggle window floating, togglefloating"
        "$mainMod, Space, Toggle focus betweeen tikled and floating layers, hy3:togglefocuslayer"

        # layout stuff
        "$mainMod, comma, Split horizontally, hy3:makegroup, h, toggle, ephemeral"
        "$mainMod Shift, comma, Change group layout to horizontal, hy3:changegroup, h"
        "$mainMod, period, Split vertically, hy3:makegroup, v, toggle, ephemeral"
        "$mainMod Shift, period, Change group layout to vertical, hy3:changegroup, v"
        "$mainMod, slash, Make tab, hy3:makegroup, tab, toggle, ephemeral"
        "$mainMod Shift, slash, Change group layout to tabbed, hy3:changegroup, toggletab"

        # misc
        "$mainMod, Escape, Expo, hyprexpo:expo, toggle"
        "$mainMod, Grave, Expo, hyprexpo:expo, toggle"
      ]
      ++ lib.flatten (
        lib'.withDirections (
          { xkbNoPrefix, hyprland, ... }:
          let
            inherit (hyprland) direction;
          in
          [
            # move focus (only visible windows)
            "$mainMod, ${xkbNoPrefix.arrow}, Move focus ${direction} (only visible windows), hy3:movefocus, ${direction}, visible, warp"
            "$mainMod, ${xkbNoPrefix.hjkl}, Move focus ${direction} (only visible windows), hy3:movefocus, ${direction}, visible, warp"

            # move focus (all windows)
            "$mainMod Alt, ${xkbNoPrefix.arrow}, Move focus ${direction}, hy3:movefocus, ${direction} (all windows), warp"
            "$mainMod Alt, ${xkbNoPrefix.hjkl}, Move focus ${direction}, hy3:movefocus, ${direction} (all windows), warp"

            # move window
            "$mainMod Shift, ${xkbNoPrefix.arrow}, Swap window ${direction}, hy3:movewindow, ${direction}"
            "$mainMod Shift, ${xkbNoPrefix.hjkl}, Swap window ${direction}, hy3:movewindow, ${direction}"

          ]
        )
      )
      ++ lib.flatten (
        lib'.withNumbers (
          { xkbNoPrefix, number, ... }:
          [
            # focus workspace
            "$mainMod, ${xkbNoPrefix.digit}, Switch to workspace ${toString number}, workspace, ${builtins.toString number}"
            "$mainMod Alt, ${xkbNoPrefix.digit}, Switch to workspace ${toString (10 + number)}, workspace, ${toString (10 + number)}"

            # focus window in tabs
            "$mainMod Control, ${xkbNoPrefix.digit}, Focus tab ${toString number}, hy3:focustab, index, ${toString number}"

            # move window to workspace
            "$mainMod Shift, ${xkbNoPrefix.digit}, Move active window to workspace ${toString number}, hy3:movetoworkspace, ${toString number}, follow, warp"
            "$mainMod Shift Alt, ${xkbNoPrefix.digit}, Move window to workspace ${toString (10 + number)}, hy3:movetoworkspace, ${toString (10 + number)}, follow, warp"
          ]
        )
      );

    bindde = lib.flatten (
      lib'.withDirections (
        {
          xkbNoPrefix,
          resizeVector,
          ...
        }:
        [
          # resize window
          "$mainMod Control, ${xkbNoPrefix.arrow}, Resize window with arrows, resizeactive, ${toString (resizeVector.x * 60)} ${toString (resizeVector.y * 60)}"
          "$mainMod Control, ${xkbNoPrefix.hjkl}, Resize window with vim keys, resizeactive, ${toString (resizeVector.x * 60)} ${toString (resizeVector.y * 60)}"
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
      "$mainMod Shift, M, Toggle mute for default audio source, exec, NONBLOCKING_NOTIFY=true '${wm-utils}' toggle_sound_mute @DEFAULT_SOURCE@"
    ];
  };

}
