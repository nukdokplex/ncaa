{ pkgs, config, ... }:
{

  stylix.iconTheme = {
    enable = true;
    package = pkgs.papirus-icon-theme.override { color = "adwaita"; };
    light = "Papirus";
    dark = "Papirus-Dark";
  };

  stylix.targets.gtk.extraCss = with config.lib.stylix; ''
    @define-color view_bg_color rgba(${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, ${toString config.stylix.opacity.applications})
  '';
}
