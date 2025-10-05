t:
{ ... }:
t {
  name = "firefox";
  humanName = "Firefox";

  config.wayland.windowManager = {
    hyprland.settings.windowrulev2 = [
      "float, class:firefox, initialTitle:Picture-in-Picture"
      "pin, class:firefox, initialTitle:Picture-in-Picture"
    ];

    sway.extraConfig = ''
      for_window [ app_id="firefox" title="Picture-in-Picture" ] floating enable, sticky enable
    '';
  };
}
