{ lib, ... }:
let
  sessionVariables = {
    # electron and chromium
    NIXOS_OZONE_WL = "1";

    # qt
    QT_QPA_PLATFORM = "wayland;xcb"; # qt apps should use wayland and fallback to x
    QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # enables automatic scaling, based on the monitor’s pixel density https://doc.qt.io/qt-5/highdpi.html
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # disables window decorations on Qt applications

    # gtk
    GDK_BACKEND = "wayland,x11,*"; # GTK: Use Wayland if available; if not, try X11 and then any other GDK backend

    # xdg
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";

    # toolkits
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };
in
{
  wayland.windowManager.hyprland = {
    settings.env = sessionVariables |> lib.attrsToList |> map (e: "${e.name},${e.value}");
    systemd.variables =
      [
        [
          "DISPLAY"
          "HYPRLAND_INSTANCE_SIGNATURE"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"
        ]
        (lib.attrNames sessionVariables)
      ]
      |> lib.concatLists
      |> lib.unique;
  };

  home = {
    inherit sessionVariables;
  };
}
