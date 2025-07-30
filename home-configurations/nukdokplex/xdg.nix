{
  lib,
  config,
  pkgs,
  ...
}:
let
  userDirs = [
    "desktop"
    "documents"
    "download"
    "music"
    "pictures"
    "publicShare"
    "templates"
    "videos"
  ];
in
{
  config = lib.mkIf config.home.isDesktop {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    }
    // builtins.listToAttrs (
      builtins.map (name: lib.nameValuePair name "${config.home.homeDirectory}/${name}") userDirs
    );

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-termfilechooser ];
      config = {
        common = {
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        };
      };
    };

    xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
      env=TERMCMD=${lib.getExe config.programs.foot.package} -a "foot-file-chooser"
    '';

    xdg.terminal-exec = {
      enable = lib.mkDefault true;
      settings = {
        default = [ "foot.desktop" ];
        GNOME = [ "foot.desktop" ];
      };
    };
  };
}
