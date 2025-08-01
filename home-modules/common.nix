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
    @define-color view_bg_color alpha(${colors.withHashtag.base00}, ${toString config.stylix.opacity.applications});

    tooltip {
      background-color: alpha(${colors.withHashtag.base00}, ${builtins.toString config.stylix.opacity.popups});
    }
    tooltip * {
      color: ${colors.withHashtag.base05};
    }
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
