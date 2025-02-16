{ pkgs, lib, config, inputs, ... }: 
let
  keySynonims = {
    directions = rec {
      Left = {
        direction = "l";
        resizeVector = { x = -1; y = 0; };
      };
      H = Left;
      Right = {
        direction = "r";
        resizeVector = { x = 1; y = 0; };
      };
      L = Right;
      Up = {
        direction = "u";
        resizeVector = { x = 0; y = -1; };
      };
      K = Up;
      Down = {
        direction = "d";
        resizeVector = { x = 0; y = 1; };
      };
      J = Down;
    };
    numbersNormal = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ];
    numbersNumpad = [ "KP_End" "KP_Down" "KP_Next" "KP_Left" "KP_Begin" "KP_Right" "KP_Home" "KP_Up" "KP_Prior" "KP_Insert" ];
  };
  resizeModifier = 60;
  generateDirectionBinds = fn: (lib.attrsets.mapAttrsToList (key: props: (fn { inherit key; inherit (props) direction; resizeX = builtins.toString (props.resizeVector.x * resizeModifier); resizeY = builtins.toString (props.resizeVector.y * resizeModifier); })) keySynonims.directions);
  generateWorkspaceBinds = fn: ((lib.lists.imap1 (i: key: (fn i key)) keySynonims.numbersNormal) ++ (lib.lists.imap1 (i: key: (fn i key)) keySynonims.numbersNumpad));
  cfg = config.wayland.windowManager.hyprland;
in
{
  options.wayland.windowManager.hyprland = {
    enableCustomConfiguration = lib.mkEnableOption "custom Hyprland configuration";
    usesBattery = lib.mkEnableOption "Hyprland configuration to enable battery management";
    beEnergyEfficient = lib.mkEnableOption "make Hyprland be energy efficient";
  };


  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    wayland.windowManager.hyprland = {
      plugins = with inputs.hyprland-plugins.packages.${pkgs.system}; [
        hyprbars
        hyprexpo
      ];
      settings = {
        "$mainMod" = "SUPER";
        # autostarts
        exec-once = [
          "'${lib.getExe pkgs.soteria}'"
          "'${lib.getExe' pkgs.networkmanagerapplet "nm-applet"}'"
        ];

        # inputs
        input = {
          follow_mouse = 1;
          touchpad = {
            clickfinger_behavior = true;
            drag_lock = true;
            natural_scroll = true;
            tap-to-click = true;
          };

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

          numlock_by_default = true;
        };
        gestures.workspace_swipe = true;

        # layouts
        dwindle = {
          pseudotile = true;
          preserve_split = true; # you probably want this

          # force_split values
          # 0 -> split follows mouse,
          # 1 -> always split to the left (new = left or top)
          # 2 -> always split to the right (new = right or bottom)
          force_split = 2;
        };

        # plugins
        plugin = {
          hyprbars = {
            bar_color = "rgb(${config.lib.stylix.colors.base01})";
            bar_height = 20;
            bar_text_size = 12;
            bar_text_font = config.stylix.fonts.sansSerif.name;
            bar_text_align = "left";
            bar_buttons_alignment = "right";
            bar_part_of_window = true;
            hyprbars-button = [
              "rgb(${config.lib.stylix.colors.base08}), 15, 󰖭, hyprctl dispatch killactive, rgb(${config.lib.stylix.colors.base05})"
              "rgb(${config.lib.stylix.colors.base0A}), 15, , hyprctl dispatch fullscreen 1, rgb(${config.lib.stylix.colors.base05})"
            ];
          };
          hyprexpo = {
            columns = 5;
            gap_size = 5;
            bg_col = "rgb(${config.lib.stylix.colors.base00})";
            workspace_method = "first 1";

            enable_gesture = true;
            gesture_fingers = 3;
            gesture_distance = 300;
            gesture_positive = true; # positive = swipe down. Negative = swipe up.
          };
        };

        # general
        general = {
          gaps_in = 5;
          gaps_out = 10;

          border_size = 3;
          layout = "dwindle";
          allow_tearing = false;
        };

        bindd = [
          "Control_L Alt_L, Delete, Open power menu, exec, '${lib.getExe pkgs.wofi-power-menu }'"
          "$mainMod, P, Screenshot screen region, exec, '${lib.getExe pkgs.grim}' -g \"$('${lib.getExe pkgs.slurp}')\" -l 6 -t png - | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'"
          "$mainMod Shift_L, P, Screenshot active output, exec, '${lib.getExe pkgs.grim}' -c -l 6 -t png -o \"$('${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"}' activeworkspace -j | '${lib.getExe pkgs.jq}' -r .monitor))\" - | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'"
          "$mainMod, T, Open clipboard history, exec, '${lib.getExe config.services.cliphist.package}' list | '${lib.getExe config.programs.wofi.package}' --dmenu -p 'Select clipboard history entry...' | '${lib.getExe config.services.cliphist.package}' decode | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'"
          "$mainMod, Insert, Enable passthrough mode (disable all binds except this one to disable), submap, passthrough"
          "$mainMod, O, Open file manager, exec, '${lib.getExe pkgs.xfce.thunar}'"
          "$mainMod Shift_L, Q, Close active window, killactive"
          "$mainMod, Z, Toggle split (top/side) of the current window, togglesplit"
          "$mainMod, F, Toggle window fullscreen, fullscreen"
          "$mainMod Shift_L, F, Toggle fake fullscreen, fullscreenstate, 0 3"
          "$mainMod, Space, Toggle window floating, togglefloating"
          "$mainMod, D, Run drun menu, exec, '${lib.getExe config.programs.wofi.package}' --show drun"
          "$mainMod, Grave, Expo, hyprexpo:expo, toggle"
        ]
        ++ generateDirectionBinds ({ key, direction, ... }: "$mainMod, ${key}, Move focus, movefocus, ${direction}")
        ++ generateDirectionBinds ({ key, direction, ... }: "$mainMod Shift_L, ${key}, Move window around, swapwindow, ${direction}")
        ++ generateDirectionBinds ({ key, resizeX, resizeY, ... }: "$mainMod Control_L, ${key}, Resize window, resizeactive, ${builtins.toString resizeX} ${builtins.toString resizeY}")
        ++ generateWorkspaceBinds (i: key: "$mainMod, ${key}, Switch to workspace ${builtins.toString i}, workspace, ${builtins.toString i}")
        ++ generateWorkspaceBinds (i: key: "$mainMod Alt_L, ${key}, Switch to workspace ${builtins.toString (10+i)}, workspace, ${builtins.toString (10+i)}")
        ++ generateWorkspaceBinds (i: key: "$mainMod Shift_L, ${key}, Move active window to workspace ${builtins.toString i}, movetoworkspace, ${builtins.toString i}")
        ++ generateWorkspaceBinds (i: key: "$mainMod Shift_L Alt_L, ${key}, Move window to workspace ${builtins.toString (10+i)}, movetoworkspace, ${builtins.toString (10+i)}");

        # binds
        binddm = [
          "$mainMod, mouse:272, Move window, movewindow"
          "$mainMod, mouse:273, Resize window, resizewindow"
        ];

        binddel = [
          ", XF86AudioRaiseVolume, Increase volume for default sink, exec, '${lib.getExe' pkgs.wireplumber "wpctl"}' set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, Decrease volume for default sink, exec, '${lib.getExe' pkgs.wireplumber "wpctl"}' set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessDown, Decrease screen brightness, exec, '${lib.getExe pkgs.brightnessctl}' set 10%-"
          ", XF86MonBrightnessUp, Increase screen brightness, exec, '${lib.getExe pkgs.brightnessctl}' set 10%+"
        ];

        binddl = [
          ", XF86AudioMute, Mute default sink, exec, '${lib.getExe' pkgs.wireplumber "wpctl"}' set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioPlay, Toggle play/pause for playback, exec, '${lib.getExe pkgs.playerctl}' play-pause"
          ", XF86AudioPrev, Previous media in playlist, exec, '${lib.getExe pkgs.playerctl}' previous"
          ", XF86AudioNext, Next media in playlist, exec, '${lib.getExe pkgs.playerctl}' next"
          "$mainMod, M, Toggle mute for default audio sink, exec, '${lib.getExe' pkgs.wireplumber "wpctl"}' set-mute @DEFAULT_AUDIO_SINK@ toggle"
          "$mainMod Shift_L, M, Toggle mute for default audio source, exec, '${lib.getExe' pkgs.wireplumber "wpctl"}' set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];

        layerrule = [
          "noanim, selection" # disable animation for some utilities like slurp
        ];

        # window rules
        windowrulev2 = [
          # network manager applet
          "float, class:nm-connection-editor"

          # qbittorrent
          "float, class:org.qbittorrent.qBittorrent, title:negative:(qBittorrent)(.*)"

          # steam
          "float, class:steam, initialTitle:negative:^(Steam)$"
        ];

        # appearance
        decoration = {
          shadow.enabled = !cfg.beEnergyEfficient;
          blur = {
            enabled = !cfg.beEnergyEfficient;
            size = 5;
            passes = 4;
            new_optimizations = true;
          };

          dim_inactive = false;
          dim_strength = 0.2;
        };

        animations = {
          enabled = true;

          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92 "
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
            "softAcDecel, 0.26, 0.26, 0.15, 1"
            "md2, 0.4, 0, 0.2, 1" # use with .2s duration
          ];

          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "windowsIn, 1, 3, md3_decel, popin 60%"
            "windowsOut, 1, 3, md3_accel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 3, md3_decel"
            # "layers, 1, 2, md3_decel, slide"
            "layersIn, 1, 3, menu_decel, slide"
            "layersOut, 1, 1.6, menu_accel"
            "fadeLayersIn, 1, 2, menu_decel"
            "fadeLayersOut, 1, 4.5, menu_accel"
            "workspaces, 1, 7, menu_decel, slide"
            # "workspaces, 1, 2.5, softAcDecel, slide"
            # "workspaces, 1, 7, menu_decel, slidefade 15%"
            # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };

        misc.vfr = cfg.beEnergyEfficient;

        xwayland.force_zero_scaling = true;

        env = [
          # GTK
          "GDK_BACKEND,wayland,x11"
          "QT_QPA_PLATFORM,wayland;xcb"

          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"

          "DESKTOP_SESSION,hyprland"

          "WLR_DRM_NO_ATOMIC,1"

          "NIXOS_OZONE_WL,1"
        ];
      };

      systemd = {
        enable = true;
        enableXdgAutostart = true;
        variables = [
          "GDK_BACKEND"
          "QT_QPA_PLATFORM"
          "QT_QPA_PLATFORMTHEME"
          # "SDL_VIDEODRIVER"
          # "CLUTTER_BACKEND"
          "DESKTOP_SESSION"
          "WLR_DRM_NO_ATOMIC"
          "NIXOS_OZONE_WL"
        ];
      };
    };
  };

  imports = [
    ./essentials.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./waybar.nix
    ./wofi.nix
  ];
}
