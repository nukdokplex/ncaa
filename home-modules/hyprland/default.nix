{
  pkgs,
  lib,
  lib',
  config,
  inputs,
  ...
}@args:
{
  wayland.windowManager.hyprland = {
    enable = lib.mkDefault (
      lib.attrByPath [
        "osConfig"
        "programs"
        "hyprland"
        "enable"
      ] false args
    );
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
        "'${lib.getExe' pkgs.pipewire "pw-cat"}' --media-role Notification -p '${pkgs.kdePackages.oxygen-sounds}/share/sounds/oxygen/stereo/desktop-login-long.ogg' &"
        "'${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent'"
      ]
      ++ (lib.optional (config.stylix.video != null)
        "'${lib.getExe config.programs.mpvpaper.package}' -o \"no-audio --hwdec=auto --loop-file --panscan=1\" '*' '${config.stylix.video}'"
      )
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
        "blur, waybar" # enable blur for waybar layer because it's not enabled by default for some reason
        "blur, wayprompt"
        "blur, notifications"
        "blur, launcher"
        "blur, gtk-layer-shell"
      ];

      # window rules
      windowrulev2 = [
        # network manager applet
        "float, class:nm-connection-editor"

        # qbittorrent
        "float, class:org.qbittorrent.qBittorrent, title:negative:(qBittorrent)(.*)"

        # steam
        "float, class:steam, initialTitle:negative:^(Steam)$"

        # firefox picture-in-picture
        "float, class:firefox, initialTitle:Picture-in-Picture"
        "pin, class:firefox, initialTitle:Picture-in-Picture"

        # udiskie
        "float, class:udiskie"

        # term file chooser
        "float, class:foot-file-chooser"
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
        "NIXOS_OZONE_WL,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "GTK_USE_PORTAL,1"
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
        "NIXOS_OZONE_WL"
        "ELECTRON_OZONE_PLATFORM_HINT"
      ];
    };
  };

  # use common wpaperd for all wayland wms
  stylix.targets.hyprland.hyprpaper.enable = false;

  imports = [
    ../wm-essentials.nix
  ]
  ++ lib'.umport {
    path = ./.;
    exclude = [ ./default.nix ];
  };
}
