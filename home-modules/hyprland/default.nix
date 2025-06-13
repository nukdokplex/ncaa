{
  pkgs,
  lib,
  lib',
  ezModules,
  config,
  inputs,
  ...
}@args:
{
  wayland.windowManager.hyprland = {
    enable = lib.mkDefault (lib.attrByPath [ "osConfig" "programs" "hyprland" "enable" ] false args);
    plugins =
      with inputs.hyprland-plugins.packages.${pkgs.system};
      with inputs.hy3.packages.${pkgs.system};
      [
        # hyprbars
        hyprexpo
        hy3
      ];
    settings = {
      "$mainMod" = "SUPER";
      # autostarts
      exec-once =
        [
          "'${lib.getExe' pkgs.pipewire "pw-cat"}' --media-role Notification -p '${pkgs.kdePackages.oxygen-sounds}/share/sounds/oxygen/stereo/desktop-login-long.ogg' &"
          "'${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent'"
        ]
        ++ builtins.map (
          e: "[workspace ${toString e.workspaceNumber} silent] ${e.command}"
        ) config.wm-settings.workspaceBoundStartup;

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
        allow_tearing = false;
      };

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
        shadow.enabled = lib.mkDefault (!config.wm-settings.beEnergyEfficient);
        blur = {
          enabled = lib.mkDefault (!config.wm-settings.beEnergyEfficient);
          size = 1;
          passes = 3;
          new_optimizations = true;
        };

        dim_inactive = false;
        dim_strength = 0.2;
      };

      animations = {
        # enabled = lib.mkDefault (!config.wm-settings.beEnergyEfficient);
        enabled = lib.mkDefault false;

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

      misc.vfr = lib.mkDefault config.wm-settings.beEnergyEfficient;

      xwayland.force_zero_scaling = true;
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
    };
  };

  imports =
    [
      ezModules.wm-essentials
    ]
    ++ lib'.umport {
      path = ./.;
      exclude = [ ./default.nix ];
    };
}
