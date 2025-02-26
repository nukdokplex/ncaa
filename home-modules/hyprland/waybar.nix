{ pkgs, lib, config, ... }:
let
  cfg = config.wayland.windowManager.hyprland;
in
{
  config = with config.lib.stylix.colors.withHashtag; lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    stylix.targets.waybar.enable = false;
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings.mainBar = {
        layer = "top";
        position = "right";
        margin = "10 10 10 0";
        modules-left = [ 
          "hyprland/workspaces"
          "group/indicators"
        ] ++ (lib.optional cfg.usesBattery "battery") ++ [
          "mpris"
        ];
        modules-right = [
          "clock"
          "idle_inhibitor"
          "wireplumber"
          "custom/notifications"
          "tray"
          "hyprland/language"
        ];
        battery = {
          format = "bat\n{capacity:03d}";
          on-update = "'${pkgs.writeShellScript "check-battery" (builtins.readFile ./scripts/check-battery.sh)}'";
          states = { critical = 20; };
          tooltip-format = ''
            Capacity: {capacity}%
            {timeTo}
            Draw: {power} watts.'';
        };
        clock = {
          calendar = {
            format = { today = "<span color='${base08}'><b><u>{}</u></b></span>"; };
            mode = "month";
            mode-mon-col = 3;
            on-click-right = "mode";
            on-scroll = 1;
            weeks-pos = "right";
          };
          format = "{:%H\n%M\n%S}";
          interval = 1;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };
        cpu = {
          format = "cpu\n{usage:03d}";
          interval = 3;
        };
        "custom/notifications" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='${base08}'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='${base08}'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='${base08}'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='${base08}'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
        "group/indicators" = {
          modules = [ "memory" "cpu" ] ++ lib.optional cfg.usesBattery [ "battery" ];
          orientation = "inherit";
        };
        "hyprland/language" = {
          format = "{}";
          format-en = "EN";
          format-ru = "RU";
        };
        "hyprland/workspaces" = {
          all-outputs = false;
          disable-click = false;
          disable-scroll = false;
          format = "{name}";
        };
        idle_inhibitor = {
          format = "inh\n{icon}";
          format-icons = {
            activated = " on";
            deactivated = "off";
          };
        };
        memory = {
          format = "mem\n{percentage:03d}";
          interval = 3;
          tooltip-format = ''
            Total: {total:.1f} GiB
            Total swap: {swapTotal:.1f} GiB
      
            Used: {used:.1f} GiB
            Used swap: {swapUsed:.1f} GiB
      
            Free: {avail:.1f} GiB
            Free swap: {swapAvail:.1f} GiB'';
        };
        mpris = {
          dynamic-order = [ "artist" "title" "album" "position" "length" ];
          format-paused = " 󰐊 ";
          format-playing = " 󰏤 ";
          format-stopped = " 󰓛 ";
        };
        tray = {
          icon-size = 24;
          spacing = 6;
        };
        wireplumber = {
          format = "vol\n{volume:03d}";
          max-volume = 150;
          on-click = "'${lib.getExe pkgs.pavucontrol}'";
          tooltip = true;
          tooltip-format = "{volume}% {node_name}";
        };
      };

      style = ''
        /* colors in comments are examples, not actual color scheme */
        @define-color base00 ${base00}; /* #00211f Default Background */
        @define-color base01 ${base01}; /* #003a38 Lighter Background (Used for status bars, line number and folding marks) */
        @define-color base02 ${base02}; /* #005453 Selection Background */
        @define-color base03 ${base03}; /* #ababab Comments, Invisibles, Line Highlighting */
        @define-color base04 ${base04}; /* #c3c3c3 Dark Foreground (Used for status bars) */
        @define-color base05 ${base05}; /* #dcdcdc Default Foreground, Caret, Delimiters, Operators */
        @define-color base06 ${base06}; /* #efefef Light Foreground (Not often used) */
        @define-color base07 ${base07}; /* #f5f5f5 Brightest Foreground (Not often used) */
        @define-color base08 ${base08}; /* #ce7e8e Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted */
        @define-color base09 ${base09}; /* #dca37c Integers, Boolean, Constants, XML Attributes, Markup Link Url */
        @define-color base0A ${base0A}; /* #bfac4e Classes, Markup Bold, Search Text Background */
        @define-color base0B ${base0B}; /* #56c16f Strings, Inherited Class, Markup Code, Diff Inserted */
        @define-color base0C ${base0C}; /* #62c0be Support, Regular Expressions, Escape Characters, Markup Quotes */
        @define-color base0D ${base0D}; /* #88b0da Functions, Methods, Attribute IDs, Headings */
        @define-color base0E ${base0E}; /* #b39be0 Keywords, Storage, Selector, Markup Italic, Diff Changed */
        @define-color base0F ${base0F}; /* #d89aba Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?> */
        
        * {
          font-family: ${config.stylix.fonts.monospace.name};
          font-size: 18px;
        }
        
        #waybar {
          background-color: @base00;
          color: @base05;
          border-radius: 0px;
          border: 3px solid @base0D;
        }
        
        #waybar.hidden {
          opacity: 0.1;
        }
        
        #waybar > box > * > widget > * {
          padding: 2.5px;
        }
        
        #waybar > box > * > widget > * {
          margin: 5px;
          background-color: @base01;
          border-radius: 0px;
          border: 0.5px solid @base02;
        }
        
        #waybar > box > * {
          margin: 5px;
        }
        
        #workspaces {
        }
        
        #workspaces > button {
          padding: 0px;
        }
        
        #workspaces .active {
          background-color: @base02;
        }
      '';
    };
  };
}
