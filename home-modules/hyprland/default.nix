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
    plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
      # hyprbars
      hyprexpo
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
        layout = "dwindle";
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
    };

    systemd = {
      enable = true;
      enableXdgAutostart = true;
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
    recursive = false;
    exclude = [
      ./default.nix
    ];
  };
}
