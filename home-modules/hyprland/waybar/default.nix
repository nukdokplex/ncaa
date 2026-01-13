{
  pkgs,
  lib,
  lib',
  config,
  ...
}:
let
  importWaybarModule = path: import path { inherit pkgs lib config; };

  modulesVertical =
    lib'.umport {
      path = ./modules/vertical;
      recursive = false;
    }
    |> map importWaybarModule
    |> lib.mergeAttrsList;

  modulesHorizontal =
    lib'.umport {
      path = ./modules/horizontal;
      recursive = false;
    }
    |> map importWaybarModule
    |> lib.mergeAttrsList;
in
{
  stylix.targets.waybar.enable = false;

  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      target = "hyprland-session.target";
      # uncomment line below to enable inspect
      # enableInspect = true;
    };

    settings = {
      horizontalBar = {
        name = "horizontal";
        id = "horizontal";
        layer = "top";
        position = "bottom";
        margin = "0 10 10 10";
        output = lib.mkDefault [ ];
        modules-left = [
          "memory"
          "cpu"
          "battery"
          "mpris"
        ];
        modules-right = [
          "clock"
          "idle_inhibitor"
          "pulseaudio#sink"
          "pulseaudio#source"
          "custom/notifications"
          "tray"
          "hyprland/language"
        ];
      }
      // modulesHorizontal;
      verticalBar = {
        name = "vertical";
        id = "vertical";
        layer = "top";
        position = "right";
        margin = "10 10 10 0";
        output = lib.mkDefault null;
        modules-left = [
          "group/indicators"
        ]
        ++ (lib.optional config.wm-settings.deviceUsesBattery "battery")
        ++ [
          "mpris"
        ];
        modules-right = [
          "clock"
          "idle_inhibitor"
          "pulseaudio#sink"
          "pulseaudio#source"
          "custom/notifications"
          "tray"
          "hyprland/language"
        ];
        "group/indicators" = {
          modules = [
            "memory"
            "cpu"
            "battery"
          ];
          orientation = "inherit";
        };
      }
      // modulesVertical;
    };

    style = with config.lib.stylix.colors; ''
      /* colors in comments are examples, not actual color scheme */
      @define-color base00 ${withHashtag.base00}; /* #00211f Default Background */
      @define-color base01 ${withHashtag.base01}; /* #003a38 Lighter Background (Used for status bars, line number and folding marks) */
      @define-color base02 ${withHashtag.base02}; /* #005453 Selection Background */
      @define-color base03 ${withHashtag.base03}; /* #ababab Comments, Invisibles, Line Highlighting */
      @define-color base04 ${withHashtag.base04}; /* #c3c3c3 Dark Foreground (Used for status bars) */
      @define-color base05 ${withHashtag.base05}; /* #dcdcdc Default Foreground, Caret, Delimiters, Operators */
      @define-color base06 ${withHashtag.base06}; /* #efefef Light Foreground (Not often used) */
      @define-color base07 ${withHashtag.base07}; /* #f5f5f5 Brightest Foreground (Not often used) */
      @define-color base08 ${withHashtag.base08}; /* #ce7e8e Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted */
      @define-color base09 ${withHashtag.base09}; /* #dca37c Integers, Boolean, Constants, XML Attributes, Markup Link Url */
      @define-color base0A ${withHashtag.base0A}; /* #bfac4e Classes, Markup Bold, Search Text Background */
      @define-color base0B ${withHashtag.base0B}; /* #56c16f Strings, Inherited Class, Markup Code, Diff Inserted */
      @define-color base0C ${withHashtag.base0C}; /* #62c0be Support, Regular Expressions, Escape Characters, Markup Quotes */
      @define-color base0D ${withHashtag.base0D}; /* #88b0da Functions, Methods, Attribute IDs, Headings */
      @define-color base0E ${withHashtag.base0E}; /* #b39be0 Keywords, Storage, Selector, Markup Italic, Diff Changed */
      @define-color base0F ${withHashtag.base0F}; /* #d89aba Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?> */

      * {
        font-family: ${config.stylix.fonts.monospace.name};
        font-size: 18px;
      }

      #waybar {
        background-color: rgba(${
          lib.concatStringsSep ", " [
            base00-rgb-r
            base00-rgb-g
            base00-rgb-b
            (toString config.stylix.opacity.desktop)
          ]
        });
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

      /* workaround for language is shown as ellipsis */
      #language {
        min-width: 26px;
      }
    '';
  };
}
