{
  lib,
  config,
  pkgs,
  ...
}:
{
  xdg = lib.mkIf config.home.isDesktop {
    portal = {
      extraPortals = with pkgs; [ xdg-desktop-portal-termfilechooser ];
      config = {
        common = {
          # use terminal file chooser
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
          # GTK portal gives you proper print dialogs.
          "org.freedesktop.impl.portal.Print" = [ "gtk" ];
          # GTK portal provides desktop settings that GTK apps query (fonts, themes, colour schemes).
          "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        };
      };
    };

    configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
      env=TERMCMD=${lib.getExe config.programs.foot.package} -a "foot-file-chooser"
    '';
  };
}
