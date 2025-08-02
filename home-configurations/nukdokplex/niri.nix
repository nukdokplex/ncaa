{
  pkgs,
  config,
  lib,
  ...
}:
let
  wm-utils = lib.getExe pkgs.wm-utils;
  xwaylandDisplay = ":0";
in
{
  config = lib.mkIf config.home.isDesktop {
    xdg.configFile."niri/config.kdl".text = with config.lib.stylix.colors.withHashtag; ''
      // startup stuff

      spawn-at-startup "sh" "-c" "systemctl --user stop niri-session.target ; systemctl --user start niri-session.target"
      spawn-at-startup "${lib.getExe pkgs.xwayland-satellite}" "${xwaylandDisplay}"
      spawn-at-startup "${pkgs.soteria}/bin/soteria"
      spawn-at-startup "${lib.getExe config.wm-settings.defaultApplications.webBrowser}"
      spawn-at-startup "${lib.getExe config.wm-settings.defaultApplications.fileManager}"
      spawn-at-startup "${lib.getExe config.wm-settings.defaultApplications.passwordManager}"
      spawn-at-startup "${lib.getExe config.wm-settings.defaultApplications.mailClient}"
      spawn-at-startup "AyuGram"
      spawn-at-startup "vesktop"
      spawn-at-startup "spotify"

      workspace "work"
      workspace "chat"
      workspace "files"
      workspace "four"
      workspace "email"
      workspace "six"
      workspace "passwords"
      workspace "eight"
      workspace "games"
      workspace "audio"

      window-rule { match at-startup=true app-id="librewolf";               open-on-workspace "work"; }
      window-rule { match at-startup=true app-id="org.gnome.Nautilus";      open-on-workspace "files"; }
      window-rule { match at-startup=true app-id="org.keepassxc.KeePassXC"; open-on-workspace "passwords"; }
      window-rule { match at-startup=true app-id="thunderbird";             open-on-workspace "email"; }
      window-rule { match at-startup=true app-id="com.ayugram.desktop";     open-on-workspace "chat"; }
      window-rule { match at-startup=true app-id="vesktop";                 open-on-workspace "chat"; }
      window-rule { match at-startup=true app-id="spotify";                 open-on-workspace "audio"; }

      // startup stuff

      // misc stuff

      prefer-no-csd
      animations { off; }

      environment {
        NIXOS_OZONE_WL "1"
        ELECTRON_OZONE_PLATFORM_HINT "wayland"
        GTK_USE_PORTAL "1"
        QT_QPA_PLATFORM "wayland"
        DISPLAY "${xwaylandDisplay}"
      }

      cursor {
        xcursor-size 32
      }

      // misc stuff

      // window rules
      window-rule { match app-id="librewolf" title="^Picture-in-Picture$"; open-floating true; }

      window-rule {
        match app-id=r#"^org\.keepassxc\.KeePassXC$"#
        match app-id=r#"^org\.gnome\.World\.Secrets$"#
        match app-id=r#"^com\.ayugram\.desktop$"#

        block-out-from "screen-capture"
      }

      window-rule { draw-border-with-background false; }

      window-rule { 
        match is-window-cast-target=true

        focus-ring {
          active-color "${red}"
          inactive-color "${red}"
        }

        border { inactive-color "${red}"; }

        shadow { color "${red}70"; }

        tab-indicator {
          active-color "${red}"
          inactive-color "${red}"
        }
      }

      // window rules

      input {
        keyboard {
          xkb {
            layout "us,ru"
            options "grp:ctrl_space_toggle"
          }
        }

        touchpad {
          tap
          dwt
          dwtp
          drag true
          drag-lock
          natural-scroll
        }

        mouse { }

        trackpoint { }

        warp-mouse-to-focus

        focus-follows-mouse max-scroll-amount="10%"
      }

      output "LG Electronics LG ULTRAWIDE 0x00000459" {
        mode "2560x1080@60.000"
        scale 1
        transform "normal"
        position x=1920 y=0
      }

      layout {
        // Set gaps around windows in logical pixels.
        gaps 10
        center-focused-column "never"

        // You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
        preset-column-widths {
          proportion 0.33333
          proportion 0.5
          proportion 0.66667
        }

        // You can also customize the heights that "switch-preset-window-height" (Mod+Shift+R) toggles between.
        // preset-window-heights { }

        // You can change the default width of the new windows.
        default-column-width { proportion 0.5; }
        // If you leave the brackets empty, the windows themselves will decide their initial width.
        // default-column-width {}

        // By default focus ring and border are rendered as a solid background rectangle
        // behind windows. That is, they will show up through semitransparent windows.
        // This is because windows using client-side decorations can have an arbitrary shape.
        //
        // If you don't like that, you should uncomment `prefer-no-csd` below.
        // Niri will draw focus ring and border *around* windows that agree to omit their
        // client-side decorations.
        //
        // Alternatively, you can override it with a window rule called
        // `draw-border-with-background`.

        // You can change how the focus ring looks.
        focus-ring {
          // How many logical pixels the ring extends out from the windows.
          width 2 

          // Color of the ring on the active monitor.
          active-color "${base0D}"

          // Color of the ring on inactive monitors.
          inactive-color "${base0E}"
        }

        border { off; }

        // You can enable drop shadows for windows.
        shadow {
          on

          // Softness controls the shadow blur radius.
          softness 30

          // Spread expands the shadow.
          spread 5

          // Offset moves the shadow relative to the window.
          offset x=0 y=5

          // You can also change the shadow color and opacity.
          color "#0007"
        }

        struts {
          left 0
          right 0
          top 0
          bottom 0
        }
      }

      binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        // menus
        Ctrl+Alt+Delete hotkey-overlay-title="Open power menu" { spawn "${wm-utils}" "fuzzel_power_menu"; }
        Mod+V hotkey-overlay-title="Open clipboard history" { spawn "sh" "-c" "'${lib.getExe config.services.cliphist.package}' list | '${lib.getExe config.programs.fuzzel.package}' --dmenu -p 'Select clipboard history entry...' | '${lib.getExe config.services.cliphist.package}' decode | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'"; }
        Mod+D hotkey-overlay-title="Run drun menu" { spawn "${lib.getExe config.programs.fuzzel.package}" "--show-actions"; }

        // screenshots
        Mod+P hotkey-overlay-title="Screenshot region" { screenshot; }
        Mod+Shift+P hotkey-overlay-title="Screenshot screen" { screenshot-screen write-to-disk=false; }

        // OCR narrator
        Mod+T hotkey-overlay-title="OCR narrator (russian)" { spawn "${wm-utils}" "ocr_narrator" "ru"; }
        Mod+Shift+T hotkey-overlay-title="OCR narrator (english)" { spawn "${wm-utils}" "ocr_narrator" "en"; }

        // OCR copy
        Mod+C hotkey-overlay-title="OCR copy (russian)" { spawn "${wm-utils}" "ocr_copy" "ru"; }
        Mod+Shift+C hotkey-overlay-title="OCR copy (english)" { spawn "${wm-utils}" "ocr_copy" "en"; }

        // Applications
        Mod+O hotkey-overlay-title="Open file manager" { spawn "${lib.getExe config.wm-settings.defaultApplications.fileManager}"; }
        Mod+U hotkey-overlay-title="Open web browser" { spawn "${lib.getExe config.wm-settings.defaultApplications.webBrowser}"; }

        Mod+Return hotkey-overlay-title="Open terminal" { spawn "${lib.getExe config.wm-settings.defaultApplications.terminal}"; }

        // window manipulation
        Mod+Shift+Q hotkey-overlay-title="Close active window" { close-window; }
        Mod+F hotkey-overlay-title="Toggle window fullscreen" { fullscreen-window; }
        Mod+Shift+F hotkey-overlay-title="Toggle window fake fullscreen" { toggle-windowed-fullscreen; }
        Mod+Space hotkey-overlay-title="Switch focus between floating and tiling" { switch-focus-between-floating-and-tiling; }
        Mod+Shift+Space hotkey-overlay-title="Toggle window floating" { toggle-window-floating; }
        

        // dynamic cast settlement
        Mod+MouseMiddle       hotkey-overlay-title="Set dynamic cast window"   { set-dynamic-cast-window;   }
        Mod+Apostrophe        hotkey-overlay-title="Set dynamic cast window"   { set-dynamic-cast-window;   }
        Mod+Shift+MouseMiddle hotkey-overlay-title="Set dynamic cast monitor"  { set-dynamic-cast-monitor;  }
        Mod+Shift+Apostrophe  hotkey-overlay-title="Set dynamic cast monitor"  { set-dynamic-cast-monitor;  }
        Mod+Ctrl+MouseMiddle  hotkey-overlay-title="Clear dynamic cast target" { clear-dynamic-cast-target; }
        Mod+Ctrl+Apostrophe   hotkey-overlay-title="Clear dynamic cast target" { clear-dynamic-cast-target; }

        // layout stuff
        Mod+Escape hotkey-overlay-title="Toggle overview" { toggle-overview; }
        Mod+R hotkey-overlay-title="Switch preset colump width" { switch-preset-column-width; }
        Mod+Shift+R hotkey-overlay-title="Switch preset colump height" { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+Alt+F { maximize-column; }
        Mod+Ctrl+F { expand-column-to-available-width; }
        Mod+Z { center-column; }
        Mod+Ctrl+Z { center-visible-columns; }
        Mod+Comma hotkey-overlay-title="toggle-column-tabbed-display" { toggle-column-tabbed-display; }

        // move stuff
        Mod+Shift+H { consume-or-expel-window-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { consume-or-expel-window-right; }

        Mod+Shift+Left  { consume-or-expel-window-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { consume-or-expel-window-right; }

        Mod+Shift+1 { move-column-to-workspace 1;  }
        Mod+Shift+2 { move-column-to-workspace 2;  }
        Mod+Shift+3 { move-column-to-workspace 3;  }
        Mod+Shift+4 { move-column-to-workspace 4;  }
        Mod+Shift+5 { move-column-to-workspace 5;  }
        Mod+Shift+6 { move-column-to-workspace 6;  }
        Mod+Shift+7 { move-column-to-workspace 7;  }
        Mod+Shift+8 { move-column-to-workspace 8;  }
        Mod+Shift+9 { move-column-to-workspace 9;  }
        Mod+Shift+0 { move-column-to-workspace 10; }

        // resize stuff
        Mod+Ctrl+H { set-column-width "-10%";  }
        Mod+Ctrl+J { set-window-height "+10%"; }
        Mod+Ctrl+K { set-window-height "-10%"; }
        Mod+Ctrl+L { set-column-width "+10%";  }

        Mod+Ctrl+Left  { set-column-width "-10%";  }
        Mod+Ctrl+Down  { set-window-height "+10%"; }
        Mod+Ctrl+Up    { set-window-height "-10%"; }
        Mod+Ctrl+Right { set-column-width "+10%";  }

        // focus stuff
        Mod+H { focus-column-or-monitor-left;  }
        Mod+J { focus-window-down;             }
        Mod+K { focus-window-up;               }
        Mod+L { focus-column-or-monitor-right; }

        Mod+Left  { focus-column-or-monitor-left;  }
        Mod+Down  { focus-window-down;             }
        Mod+Up    { focus-window-up;               }
        Mod+Right { focus-column-or-monitor-right; }

        Mod+1 { focus-workspace 1;  }
        Mod+2 { focus-workspace 2;  }
        Mod+3 { focus-workspace 3;  }
        Mod+4 { focus-workspace 4;  }
        Mod+5 { focus-workspace 5;  }
        Mod+6 { focus-workspace 6;  }
        Mod+7 { focus-workspace 7;  }
        Mod+8 { focus-workspace 8;  }
        Mod+9 { focus-workspace 9;  }
        Mod+0 { focus-workspace 10; }

        // media stuff
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_SINK@" "5%-";                  }
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_SINK@" "5%+";                  }
        XF86AudioMute        { spawn "sh" "-c" "'${wm-utils}' toggle_sound_mute @DEFAULT_SINK@";   }

        Alt+XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_SOURCE@" "5%-";                                        }
        Alt+XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_SOURCE@" "5%+";                                        }
        XF86AudioMicMute         { spawn "sh" "-c" "NONBLOCKING_NOTIFY=true '${wm-utils}' toggle_sound_mute @DEFAULT_SOURCE@"; }

        XF86AudioPlay        { spawn "${lib.getExe pkgs.playerctl}" "play-pause"; }
        XF86AudioStop        { spawn "${lib.getExe pkgs.playerctl}" "stop";       }
        XF86AudioPrev        { spawn "${lib.getExe pkgs.playerctl}" "previous";   }
        XF86AudioNext        { spawn "${lib.getExe pkgs.playerctl}" "next";       }
      }

    '';
  };
}
