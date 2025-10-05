t:
{ ... }:
t {
  name = "udiskie";

  config.wayland.windowManager = {
    hyprland.settings.windowrulev2 = [
      "float, class:udiskie"
    ];

    sway.extraConfig = ''
      for_window [app_id="udiskie"] floating enable
    '';
  };
}
