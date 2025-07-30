{
  pkgs,
  config,
  lib,
  ...
}:
{

  stylix.iconTheme = {
    enable = true;
    package = pkgs.papirus-icon-theme.override { color = "adwaita"; };
    light = "Papirus";
    dark = "Papirus-Dark";
  };

  stylix.targets.gtk.extraCss = with config.lib.stylix; ''
    @define-color view_bg_color rgba(${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, ${toString config.stylix.opacity.applications});
  '';

  xdg.configFile =
    let
      qtctCfg = ''
        standard_dialogs=xdgdesktopportal
      '';
    in
    {
      # addition to stylix qtct configuration
      "qt5ct/qt5ct.conf".text = lib.mkOrder 1050 qtctCfg;
      "qt6ct/qt6ct.conf".text = lib.mkOrder 1050 qtctCfg;
    };
}
