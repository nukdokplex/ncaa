{
  lib,
  config,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = with config.lib.stylix.colors; {
    plugin.hy3 = {
      # disable gaps when only one window is onscreen
      # 0 - always show gaps
      # 1 - hide gaps with a single window onscreen
      # 2 - 1 but also show the window border
      no_gaps_when_only = 0; # default: 0

      # policy controlling what happens when a node is removed from a group,
      # leaving only a group
      # 0 = remove the nested group
      # 1 = keep the nested group
      # 2 = keep the nested group only if its parent is a tab group
      node_collapse_policy = 2; # default: 2

      # offset from group split direction when only one window is in a group
      group_inset = 10; # default: 10

      # if a tab group will automatically be created for the first window spawned in a workspace
      tab_first_window = false;

      tabs = {
        # height of the tab bar
        height = 28; # default: 22

        # padding between the tab bar and its focused node
        padding = 6; # default: 6

        # the tab bar should animate in/out from the top instead of below the window
        from_top = true; # default: false

        # radius of tab bar corners
        radius = 0; # default: 6

        # tab bar border width
        border_width = 3; # default: 2

        # render the window title on the bar
        render_text = true; # default: true

        # center the window title
        text_center = false; # default: true

        # font to render the window title with
        text_font = config.stylix.fonts.sansSerif.name; # default: Sans

        # height of the window title
        text_height = 14; # default: 8

        # left padding of the window title
        text_padding = 9; # default: 3

        # selected tab and group is focused
        "col.active" = "rgba(${base02}40)";
        "col.active.border" = "rgba(${base0D}ee)";
        "col.active.text" = "rgba(${base05}ff)";

        # selected tab and group is unfocused (yeah, that's right)
        "col.focused" = "rgba(${base02}40)";
        "col.focused.border" = "rgba(${base0E}ee)";
        "col.focused.text" = "rgba(${base05}ff)";

        # not-selected tab
        "col.inactive" = "rgba(${base00}40)";
        "col.inactive.border" = "rgba(${base03}ee)";
        "col.inactive.text" = "rgba(${base05}ff)";

        "col.urgent" = "rgba(${base00}40)";
        "col.urgent.border" = "rgba(${base0A}ee)";
        "col.urgent.text" = "rgba(${base05}ff)";

        "col.locked" = "rgba(${base00}40)";
        "col.locked.border" = "rgba(${base08}ee)";
        "col.locked.text" = "rgba(${base05}ff)";

        # if tab backgrounds should be blurred
        # Blur is only visible when the above colors are not opaque.
        blur = lib.mkDefault (!config.wm-settings.beEnergyEfficient); # default: true

        # opacity multiplier for tabs
        # Applies to blur as well as the given colors.
        opacity = 1.0; # default: 1.0
      };

      autotile = {
        # enable autotile
        enable = false; # default: false

        # make autotile-created groups ephemeral
        ephemeral_groups = true; # default: true

        # if a window would be squished smaller than this width, a vertical split will be created
        # -1 = never automatically split vertically
        # 0 = always automatically split vertically
        # <number> = pixel width to split at
        trigger_width = 0; # default: 0

        # if a window would be squished smaller than this height, a horizontal split will be created
        # -1 = never automatically split horizontally
        # 0 = always automatically split horizontally
        # <number> = pixel height to split at
        trigger_height = 0; # default: 0

        # a space or comma separated list of workspace ids where autotile should be enabled
        # it's possible to create an exception rule by prefixing the definition with "not:"
        # workspaces = 1,2 # autotiling will only be enabled on workspaces 1 and 2
        # workspaces = not:1,2 # autotiling will be enabled on all workspaces except 1 and 2
        workspaces = "all"; # default: all
      };
    };
  };
}
