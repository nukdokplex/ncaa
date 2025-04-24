{ pkgs, lib, config, inputs, ... }@args: let
  cfg = config.wayland.windowManager.sway;
  wm-utils = "'${lib.getExe inputs.self.packages.${pkgs.system}.wm-utils}'";
in {
  options.wayland.windowManager.sway = {
    enableCustomConfiguration = lib.mkEnableOption "sway custom configuration";
    usesBattery = lib.mkEnableOption "Hyprland configuration to enable battery management";
    beEnergyEfficient = lib.mkEnableOption "make Hyprland be energy efficient";
    workspaceBoundStartup = lib.mkOption {
      description = "Workspace-bound startups";
      type = lib.types.listOf (lib.types.submodule {
        options = {
          workspaceNumber = lib.mkOption {
            type = lib.types.ints.unsigned;
            description = "workspace number in which window should be spawned";
          };
          command = lib.mkOption {
            type = lib.types.str;
            description = "command to execute";
          };
        };
      });
    };
    programs = let 
      mkExeOption = name: default: lib.mkOption {
        inherit default;
        description = "Default ${name} program to use";
        type = lib.types.string;
      };
    in {
      fileManager = mkExeOption "file manager" "thunar";
      webBrowser = mkExeOption "web browser" "firefox";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    wayland.windowManager.sway = {
      checkConfig = false;
      package = if (builtins.hasAttr "osConfig" args)
        then args.osConfig.programs.sway.package
        else pkgs.sway;
      wrapperFeatures.gtk.enable = true;
      config = rec {
        startup = lib.mkBefore [
          { command = "'${lib.getExe pkgs.soteria}'"; }
        ];
        bars = [ ]; # remove standard bar

        gaps.inner = 10;
        gaps.outer = 10;
        window.border = 3;
        floating.border = cfg.config.window.border;

        defaultWorkspace = "workspace number 1";

        modifier = "Mod4";
        focus.mouseWarping = "container";
        menu = lib.mkDefault "'${lib.getExe config.programs.fuzzel.package}' --show-actions";
        bindkeysToCode = true; # workaround for multilayout setups
        keybindings = {
          "--no-repeat Ctrl+Alt+Delete" = "exec ${wm-utils} fuzzel_power_menu";
          "--no-repeat ${modifier}+p" = "exec ${wm-utils} screenshot_region";
          "--no-repeat ${modifier}+Shift+p" = "exec ${wm-utils} screenshot_output";
          "--no-repeat ${modifier}+t" = "exec '${lib.getExe config.services.cliphist.package}' list | '${lib.getExe config.programs.fuzzel.package}' --dmenu -p 'Select clipboard history entry...' | '${lib.getExe config.services.cliphist.package}' decode | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'";
          "--no-repeat ${modifier}+Insert" = "mode passthrough; floating_modifer none";
          "--no-repeat ${modifier}+Shift+q" = "kill";
          "--no-repeat ${modifier}+Return" = "exec ${cfg.config.terminal}";
          "--no-repeat ${modifier}+d" = "exec ${cfg.config.menu}";

          "--no-repeat ${modifier}+${cfg.config.left}" = "focus left";
          "--no-repeat ${modifier}+${cfg.config.down}" = "focus down";
          "--no-repeat ${modifier}+${cfg.config.up}" = "focus up";
          "--no-repeat ${modifier}+${cfg.config.right}" = "focus right";

          "--no-repeat ${modifier}+Left" = "focus left";
          "--no-repeat ${modifier}+Down" = "focus down";
          "--no-repeat ${modifier}+Up" = "focus up";
          "--no-repeat ${modifier}+Right" = "focus right";

          "--no-repeat ${modifier}+Shift+${cfg.config.left}" = "move left";
          "--no-repeat ${modifier}+Shift+${cfg.config.down}" = "move down";
          "--no-repeat ${modifier}+Shift+${cfg.config.up}" = "move up";
          "--no-repeat ${modifier}+Shift+${cfg.config.right}" = "move right";

          "--no-repeat ${modifier}+Shift+Left" = "move left";
          "--no-repeat ${modifier}+Shift+Down" = "move down";
          "--no-repeat ${modifier}+Shift+Up" = "move up";
          "--no-repeat ${modifier}+Shift+Right" = "move right";

          "${modifier}+Ctrl+${cfg.config.left}" = "resize shrink width 10 px";
          "${modifier}+Ctrl+${cfg.config.down}" = "resize grow height 10 px";
          "${modifier}+Ctrl+${cfg.config.up}" = "resize shrink height 10 px";
          "${modifier}+Ctrl+${cfg.config.right}" = "resize grow width 10 px";

          "${modifier}+Ctrl+Left" = "resize shrink width 10 px";
          "${modifier}+Ctrl+Down" = "resize grow height 10 px";
          "${modifier}+Ctrl+Up" = "resize shrink heigt 10 px";
          "${modifier}+Ctrl+Right" = "resize grow width 10 px";

          "--no-repeat ${modifier}+b" = "splith";
          "--no-repeat ${modifier}+v" = "splitv";
          "--no-repeat ${modifier}+f" = "fullscreen toggle";
          "--no-repeat ${modifier}+a" = "focus parent";

          "--no-repeat ${modifier}+s" = "layout stacking";
          "--no-repeat ${modifier}+w" = "layout tabbed";
          "--no-repeat ${modifier}+e" = "layout toggle split";

          "--no-repeat ${modifier}+Shift+space" = "floating toggle";
          "--no-repeat ${modifier}+space" = "focus mode_toggle";

          "--no-repeat ${modifier}+1" = "workspace number 1";
          "--no-repeat ${modifier}+2" = "workspace number 2";
          "--no-repeat ${modifier}+3" = "workspace number 3";
          "--no-repeat ${modifier}+4" = "workspace number 4";
          "--no-repeat ${modifier}+5" = "workspace number 5";
          "--no-repeat ${modifier}+6" = "workspace number 6";
          "--no-repeat ${modifier}+7" = "workspace number 7";
          "--no-repeat ${modifier}+8" = "workspace number 8";
          "--no-repeat ${modifier}+9" = "workspace number 9";
          "--no-repeat ${modifier}+0" = "workspace number 10";

          "--no-repeat ${modifier}+Alt+1" = "workspace number 11";
          "--no-repeat ${modifier}+Alt+2" = "workspace number 12";
          "--no-repeat ${modifier}+Alt+3" = "workspace number 13";
          "--no-repeat ${modifier}+Alt+4" = "workspace number 14";
          "--no-repeat ${modifier}+Alt+5" = "workspace number 15";
          "--no-repeat ${modifier}+Alt+6" = "workspace number 16";
          "--no-repeat ${modifier}+Alt+7" = "workspace number 17";
          "--no-repeat ${modifier}+Alt+8" = "workspace number 18";
          "--no-repeat ${modifier}+Alt+9" = "workspace number 19";
          "--no-repeat ${modifier}+Alt+0" = "workspace number 20";

          "--no-repeat ${modifier}+Shift+1" = "move container to workspace number 1; workspace number 1";
          "--no-repeat ${modifier}+Shift+2" = "move container to workspace number 2; workspace number 2";
          "--no-repeat ${modifier}+Shift+3" = "move container to workspace number 3; workspace number 3";
          "--no-repeat ${modifier}+Shift+4" = "move container to workspace number 4; workspace number 4";
          "--no-repeat ${modifier}+Shift+5" = "move container to workspace number 5; workspace number 5";
          "--no-repeat ${modifier}+Shift+6" = "move container to workspace number 6; workspace number 6";
          "--no-repeat ${modifier}+Shift+7" = "move container to workspace number 7; workspace number 7";
          "--no-repeat ${modifier}+Shift+8" = "move container to workspace number 8; workspace number 8";
          "--no-repeat ${modifier}+Shift+9" = "move container to workspace number 9; workspace number 9";
          "--no-repeat ${modifier}+Shift+0" = "move container to workspace number 10; workspace number 10";

          "--no-repeat ${modifier}+Shift+Alt+1" = "move container to workspace number 11; workspace number 11";
          "--no-repeat ${modifier}+Shift+Alt+2" = "move container to workspace number 12; workspace number 12";
          "--no-repeat ${modifier}+Shift+Alt+3" = "move container to workspace number 13; workspace number 13";
          "--no-repeat ${modifier}+Shift+Alt+4" = "move container to workspace number 14; workspace number 14";
          "--no-repeat ${modifier}+Shift+Alt+5" = "move container to workspace number 15; workspace number 15";
          "--no-repeat ${modifier}+Shift+Alt+6" = "move container to workspace number 16; workspace number 16";
          "--no-repeat ${modifier}+Shift+Alt+7" = "move container to workspace number 17; workspace number 17";
          "--no-repeat ${modifier}+Shift+Alt+8" = "move container to workspace number 18; workspace number 18";
          "--no-repeat ${modifier}+Shift+Alt+9" = "move container to workspace number 19; workspace number 19";
          "--no-repeat ${modifier}+Shift+Alt+0" = "move container to workspace number 20; workspace number 20";

          "--no-repeat ${modifier}+Shift+minus" = "move scratchpad";
          "--no-repeat ${modifier}+minus" = "scratchpad show";

          "--no-repeat ${modifier}+Shift+c" = "reload";

          "--no-repeat ${modifier}+r" = "mode resize";

          "--locked XF86MonBrightnessUp" = "exec '${lib.getExe pkgs.brightnessctl}' set 5%+"; 
          "--locked XF86MonBrightnessDown" = "exec '${lib.getExe pkgs.brightnessctl}' set 5%-";  
          "--locked XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%+";
          "--locked XF86AudioLowerVolume" = "exec wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%-";
          "--no-repeat --locked XF86AudioMute" = "exec ${wm-utils} toggle_sound_mute @DEFAULT_SINK@";
        };
      };
      extraConfig = ''
        for_window [app_id="dragon-drop"] floating enable, sticky enable
      '' + "\n" + lib.concatStringsSep "\n" (
        builtins.map
        (elem: "workspace number ${builtins.toString elem.workspaceNumber}; exec ${elem.command}") 
        (lib.reverseList (
          lib.sortOn (x: x.workspaceNumber) cfg.workspaceBoundStartup
        ))
      ) + "\n" + lib.optionalString (cfg.package.pname == "swayfx") ''
        blur ${if cfg.beEnergyEfficient then "disable" else "enable"}
        blur_xray disable
        blur_passes 3
        blur_radius 1
        blur_noise 0
        blur_brightness 1
        blur_contrast 1
        blur_saturation 1

        shadows disable'';
    };
  };

  imports = [
    ./essentials.nix
    ./fuzzel.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
  ];
}
