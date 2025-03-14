{ pkgs, lib, config, ... }@args: let
  cfg = config.wayland.windowManager.sway;
  fuzzelPowerMenu = pkgs.writeShellScript "fuzzel-power-menu" (builtins.readFile ./scripts/fuzzel-power-menu.sh);
in {
  options.wayland.windowManager.sway = {
    enableCustomConfiguration = lib.mkEnableOption "sway custom configuration";
    usesBattery = lib.mkEnableOption "Hyprland configuration to enable battery management";
    beEnergyEfficient = lib.mkEnableOption "make Hyprland be energy efficient";
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
        menu = lib.mkDefault "'${lib.getExe config.programs.fuzzel.package}' --show-actions";
        bindkeysToCode = true; # workaround for multilayout setups
        keybindings = {
          "Ctrl+Alt+Delete" = "exec '${fuzzelPowerMenu}'";
          "${modifier}+p" = "exec '${lib.getExe pkgs.grim}' -g \"$('${lib.getExe pkgs.slurp}')\" -l 6 -t png - | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'";
          "${modifier}+Shift+p" = "exec '${lib.getExe pkgs.grim}' -c -l 6 -t png -o \"$('${lib.getExe' pkgs.sway "swaymsg"}' -t get_workspaces | '${lib.getExe pkgs.jq}' -r '.[] | select(.focused==true).output')\" - | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'";
          "${modifier}+t" = "exec '${lib.getExe config.services.cliphist.package}' list | '${lib.getExe config.programs.fuzzel.package}' --dmenu -p 'Select clipboard history entry...' | '${lib.getExe config.services.cliphist.package}' decode | '${lib.getExe' pkgs.wl-clipboard "wl-copy"}'";
          "${modifier}+Insert" = "mode passthrough; floating_modifer none";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+Return" = "exec ${cfg.config.terminal}";
          "${modifier}+d" = "exec ${cfg.config.menu}";

          "${modifier}+${cfg.config.left}" = "focus left";
          "${modifier}+${cfg.config.down}" = "focus down";
          "${modifier}+${cfg.config.up}" = "focus up";
          "${modifier}+${cfg.config.right}" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+${cfg.config.left}" = "move left";
          "${modifier}+Shift+${cfg.config.down}" = "move down";
          "${modifier}+Shift+${cfg.config.up}" = "move up";
          "${modifier}+Shift+${cfg.config.right}" = "move right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+Ctrl+${cfg.config.left}" = "resize shrink width 10 px";
          "${modifier}+Ctrl+${cfg.config.down}" = "resize grow height 10 px";
          "${modifier}+Ctrl+${cfg.config.up}" = "resize shrink height 10 px";
          "${modifier}+Ctrl+${cfg.config.right}" = "resize grow width 10 px";

          "${modifier}+Ctrl+Left" = "resize shrink width 10 px";
          "${modifier}+Ctrl+Down" = "resize grow height 10 px";
          "${modifier}+Ctrl+Up" = "resize shrink heigt 10 px";
          "${modifier}+Ctrl+Right" = "resize grow width 10 px";

          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+a" = "focus parent";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";

          "${modifier}+Alt+1" = "workspace number 11";
          "${modifier}+Alt+2" = "workspace number 12";
          "${modifier}+Alt+3" = "workspace number 13";
          "${modifier}+Alt+4" = "workspace number 14";
          "${modifier}+Alt+5" = "workspace number 15";
          "${modifier}+Alt+6" = "workspace number 16";
          "${modifier}+Alt+7" = "workspace number 17";
          "${modifier}+Alt+8" = "workspace number 18";
          "${modifier}+Alt+9" = "workspace number 19";
          "${modifier}+Alt+0" = "workspace number 20";

          "${modifier}+Shift+1" = "move container to workspace number 1; workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2; workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3; workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4; workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5; workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6; workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7; workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8; workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9; workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10; workspace number 10";

          "${modifier}+Shift+Alt+1" = "move container to workspace number 11; workspace number 11";
          "${modifier}+Shift+Alt+2" = "move container to workspace number 12; workspace number 12";
          "${modifier}+Shift+Alt+3" = "move container to workspace number 13; workspace number 13";
          "${modifier}+Shift+Alt+4" = "move container to workspace number 14; workspace number 14";
          "${modifier}+Shift+Alt+5" = "move container to workspace number 15; workspace number 15";
          "${modifier}+Shift+Alt+6" = "move container to workspace number 16; workspace number 16";
          "${modifier}+Shift+Alt+7" = "move container to workspace number 17; workspace number 17";
          "${modifier}+Shift+Alt+8" = "move container to workspace number 18; workspace number 18";
          "${modifier}+Shift+Alt+9" = "move container to workspace number 19; workspace number 19";
          "${modifier}+Shift+Alt+0" = "move container to workspace number 20; workspace number 20";

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+Shift+c" = "reload";

          "${modifier}+r" = "mode resize";
        };
      };
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
