t:
{ ... }:
t {
  name = "xdg-desktop-portal-termfilechooser";
  # TODO: add another terms

  config.wayland.windowManager = {
    hyprland.settings.windowrulev2 = [
      "float, class:foot-file-chooser"
    ];

    sway.extraConfig = ''
      for_window [ app_id="foot-file-chooser" ] floating enable
    '';
  };
}
