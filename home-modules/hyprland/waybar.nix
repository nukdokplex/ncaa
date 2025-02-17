{ pkgs, lib, config, ... }:
let
  cfg = config.wayland.windowManager.hyprland;
in
{
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "bottom";
          postition = "top";
          margin-top = 10;
          margin-bottom = 0;
          margin-left = 10;
          margin-right = 10;
          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [ "clock" ];
          modules-right = [
            "idle_inhibitor"
            "wireplumber"
            "tray"
          ] ++ (lib.optional cfg.usesBattery "battery") ++ [
            "hyprland/language"
          ];
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          "hyprland/workspaces" = {
            all-outputs = false;
            format = "{name}";
            disable-scroll = false;
            disable-click = false;
          };
          "hyprland/window" = {
            format = "{title} ({class})";
            all-outputs = true;
          };
          "hyprland/language" = {
            format = "{}";
          };
          clock = {
            format = "{:L%A, %d %B %Y - %H:%M:%S}";
            interval = 1;
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            locale = "ru_RU.UTF-8";
            calendar = with config.lib.stylix.colors.withHashtag; {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                days = "<span color='${base05}'><b>{}</b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };
          wireplumber = {
            format = "{volume}% {icon}";
            format-icons = [ "" "" "" ];
            tooltip = true;
            tooltip-format = "{node_name}";
            max-volume = 150.0;
            on-click = lib.getExe pkgs.pavucontrol;
          };
          network = {
            format-disabled = "󰀝";
            format-disconnected = "󰀦";
            format-ethernet = "󰈀";
            format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];
            format-wifi = "{icon}";
            on-click = lib.getExe' pkgs.networkmanagerapplet "nm-connection-editor";
            tooltip-format = "{ifname} via {gwaddr} 󰊗";
            tooltip-format-disconnected = "Disconnected";
            tooltip-format-ethernet = "{ifname} ";
            tooltip-format-wifi = "{essid} ({signalStrength}%) {icon}";
          };
          bluetooth = {
            format = "";
            format-connected = " {num_connections}";
            format-disabled = ""; # an empty format will hide the module
            on-click = lib.getExe' pkgs.blueman "blueman-manager";
            tooltip-format = "{controller_alias}	{controller_address}";

            tooltip-format-connected = ''
              {controller_alias}	{controller_address}

              {device_enumerate}'';

            tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
          };
          tray = {
            spacing = 15;
          };
          "custom/menu" = {
            format = "󰀻";
            on-click = "${lib.getExe pkgs.nwg-drawer}";
            tooltip-format = "Touch-friendly application menu.";
          };
          power-profiles-daemon = {
            format = "{icon}";

            format-icons = {
              balanced = "󰗑";
              default = "󰗑";
              performance = "󱐌";
              power-saver = "󰌪";
            };

            tooltip-format = ''
              Profile: {profile}
              Driver: {driver}'';

            tooltip = true;
          };
          battery = {
            format = "{icon}";
            format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];

            on-update = "${pkgs.writeShellScript "check-battery" (builtins.readFile ./scripts/check-battery.sh)}";
            tooltip-format = ''
              {capacity}%: {timeTo}.
              Draw: {power} watts.'';

            states = { critical = 20; };
          };
        };
      };

      style = with config.lib.stylix.colors.withHashtag; ''
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
          /* that's kinda tricky solution for clipping icons */
          font-family: ${config.stylix.fonts.sansSerif.name}, Symbols Nerd Font;
          font-size: 10pt;
        }

        #waybar {
          background-color: @base00;
          color: @base05;
          border-radius: 0px;
          border: 2px solid @base0D;
          padding: 10px 10px;
        }

        #waybar.hidden {
          opacity: 0.1;
        }

        #waybar > box > * > widget > * {
          padding: 0px 6px;
          margin: 12px 6px;
          background-color: @base01;
          border-radius: 0px;
          border: 0.5px solid @base02;
        }

        .modules-left {
          margin-left: 6px;
        }

        .modules-right {
          margin-right: 6px;
        }

        #waybar > box > * > widget > box > widget > * {
          padding: 0px 3px;
          background-color: @base00;
          border-radius: 0px; 
          margin: 3px;
          border: 0.5px solid @base02;
        }

        #waybar > box > * > widget > box > :first-child > * {
          margin-left: 0px;
        }

        #waybar > box > * > widget > box > :last-child > * {
          margin-right: 0px;
        }

        #workspaces {
          padding: 0px 0px;
        }

        #workspaces> * {
          padding: 0px 3px;
          margin: 0px 0px;
          border-radius: 0.5px; 
        }

        #workspaces .active {
          background-color: @base02;
        }
      '';
    };
  };
}
