{
  config,
  pkgs,
  lib,
  lib',
  ...
}:
let
  cfg = config.wayland.windowManager.sway;
in
{
  wayland.windowManager.sway.config = lib.fix (final: {
    modifier = "Mod4";
    keybindings =
      let
        modifier = config.wayland.windowManager.sway.config.modifier;
        wm-utils = lib.getExe pkgs.wm-utils;
      in
      {
        "--no-repeat Ctrl+Alt+Delete" = "exec '${wm-utils}' fuzzel_power_menu";
        "--no-repeat ${modifier}+p" = "exec '${wm-utils}' screenshot_region";
        "--no-repeat ${modifier}+Shift+p" = "exec '${wm-utils}' screenshot_output";
        "--no-repeat ${modifier}+t" =
          "exec cliphist list | fuzzel --dmenu -p 'Select clipboard history entry...' | cliphist decode | wl-copy";
        "--no-repeat ${modifier}+Insert" = "mode passthrough; floating_modifer none";
        "--no-repeat ${modifier}+Shift+q" = "kill";
        "--no-repeat ${modifier}+Return" =
          "exec '${lib.getExe config.wm-settings.defaultApplications.terminal}'";
        "--no-repeat ${modifier}+o" =
          "exec '${lib.getExe config.wm-settings.defaultApplications.fileManager}'";
        "--no-repeat ${modifier}+u" =
          "exec '${lib.getExe config.wm-settings.defaultApplications.webBrowser}'";
        "--no-repeat ${modifier}+d" = "exec ${cfg.config.menu}";

        "--no-repeat ${modifier}+b" = "splith";
        "--no-repeat ${modifier}+v" = "splitv";
        "--no-repeat ${modifier}+f" = "fullscreen toggle";
        "--no-repeat ${modifier}+a" = "focus parent";

        "--no-repeat ${modifier}+s" = "layout stacking";
        "--no-repeat ${modifier}+w" = "layout tabbed";
        "--no-repeat ${modifier}+e" = "layout toggle split";

        "--no-repeat ${modifier}+Shift+Space" = "floating toggle";
        "--no-repeat ${modifier}+Space" = "focus mode_toggle";

        "--no-repeat ${modifier}+Shift+minus" = "move scratchpad";
        "--no-repeat ${modifier}+minus" = "scratchpad show";

        "--no-repeat ${modifier}+Shift+c" = "reload";

        "--no-repeat ${modifier}+r" = "mode resize";

        "--locked XF86MonBrightnessUp" = "exec '${lib.getExe pkgs.brightnessctl}' set 5%+";
        "--locked XF86MonBrightnessDown" = "exec '${lib.getExe pkgs.brightnessctl}' set 5%-";
        "--locked XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%+";
        "--locked XF86AudioLowerVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%-";
        "--no-repeat --locked XF86AudioMute" = "exec '${wm-utils}' toggle_sound_mute @DEFAULT_SINK@";
        "--no-repeat --locked ${modifier}+M" = "exec '${wm-utils}' toggle_sound_mute @DEFAULT_SINK@";
        "--no-repeat --locked ${modifier}+Shift+M" =
          "exec '${wm-utils}' toggle_sound_mute @DEFAULT_SOURCE@";
      }
      // builtins.listToAttrs (
        lib.flatten (
          lib'.withDirections (
            {
              xkbNoPrefix,
              direction,
              swayResize,
              ...
            }:
            [
              # focus window
              (lib.nameValuePair "--no-repeat ${modifier}+${xkbNoPrefix.arrow}" "focus ${direction}")
              (lib.nameValuePair "--no-repeat ${modifier}+${xkbNoPrefix.hjkl}" "focus ${direction}")

              # move window
              (lib.nameValuePair "--no-repeat ${modifier}+Shift+${xkbNoPrefix.arrow}" "move ${direction}")
              (lib.nameValuePair "--no-repeat ${modifier}+Shift+${xkbNoPrefix.hjkl}" "move ${direction}")

              # resize window
              (lib.nameValuePair "${modifier}+Ctrl+${xkbNoPrefix.arrow}" "${swayResize} 10px")
              (lib.nameValuePair "${modifier}+Ctrl+${xkbNoPrefix.hjkl}" "${swayResize} 10px")
            ]
          )
          ++ lib'.withNumbers (
            { number, xkbNoPrefix, ... }:
            [
              # switch to workspace
              (lib.nameValuePair "${modifier}+${xkbNoPrefix.digit}" "workspace number ${toString number}")
              (lib.nameValuePair "${modifier}+Alt+${xkbNoPrefix.digit}" "workspace number ${toString (10 + number)}")

              # move window to workspace
              (lib.nameValuePair "${modifier}+Shift+${xkbNoPrefix.digit}" "move container to workspace number ${toString number}; workspace number ${toString number}")
              (lib.nameValuePair "${modifier}+Shift+Alt+${xkbNoPrefix.digit}" "move container to workspace number ${toString (10 + number)}; workspace number ${toString (10 + number)}")
            ]
          )
        )
      );
  });
}
