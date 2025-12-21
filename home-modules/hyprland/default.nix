{
  pkgs,
  lib,
  lib',
  config,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    plugins =
      with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system};
      with inputs.hy3.packages.${pkgs.stdenv.hostPlatform.system};
      [
        # hyprbars
        hyprexpo
        hy3
      ];
    settings = {
      "$mainMod" = "SUPER";
      # autostarts
      exec-once = [
        "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
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
      gestures.workspace = true;

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

      general = {
        gaps_in = 5;
        gaps_out = 10;

        border_size = 3;
        layout = "hy3";
        allow_tearing = true;
      };

      layerrule = [
        "noanim, selection" # disable animation for some utilities like slurp
        "blur, wayprompt"
        "blur, notifications"
        "blur, launcher"
        "blur, gtk-layer-shell"
      ];

      # appearance
      decoration = {
        shadow.enabled = lib.mkDefault (!config.wm-settings.beEnergyEfficient);
        blur = {
          enabled = lib.mkDefault (!config.wm-settings.beEnergyEfficient);
          size = 7;
          passes = 4;
          new_optimizations = true;
        };

        dim_inactive = false;
        dim_strength = 0.2;
      };

      animations.enabled = false;

      misc.vfr = lib.mkDefault config.wm-settings.beEnergyEfficient;

      xwayland.force_zero_scaling = true;

      env = [
        # electron and chromium
        # "NIXOS_OZONE_WL,1" # already caught by $XDG_SESSION_TYPE

        # qt
        "QT_QPA_PLATFORM,wayland;xcb" # qt apps should use wayland and fallback to x
        "QT_AUTO_SCREEN_SCALE_FACTOR,1" # enables automatic scaling, based on the monitor’s pixel density https://doc.qt.io/qt-5/highdpi.html
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1" # disables window decorations on Qt applications

        # gtk
        "GDK_BACKEND,wayland,x11,*" # GTK: Use Wayland if available; if not, try X11 and then any other GDK backend

        # xdg
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        # toolkit backend vars
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
      ];
    };

    extraConfig = ''
      bindd = $mainMod, Insert, Enable passthrough mode (disable all binds except this one to disable), submap, passthrough  

      submap = passthrough
      bindd = $mainMod, Insert, Exit passthrough mode, submap, reset

      submap = reset
    '';

    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = [
        "QT_QPA_PLATFORM"
        "QT_AUTO_SCREEN_SCALE_FACTOR"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION"
        "GDK_BACKEND"
        "XDG_CURRENT_DESKTOP"
        "XDG_SESSION_TYPE"
        "XDG_SESSION_DESKTOP"
        "SDL_VIDEODRIVER"
        "CLUTTER_BACKEND"
      ];
    };
  };

  # use common wpaperd for all wayland wms
  # check out wm-essentials
  stylix.targets.hyprland.hyprpaper.enable = false;

  imports = [
    ../wm-essentials.nix
  ]
  ++ lib'.umport {
    path = ./.;
    exclude = [
      ./default.nix
      ./startup-sound.nix
    ];
  };
}
