t:
{ ... }:
t {
  name = "waybar";

  config.wayland.windowManager = {
    hyprland.settings.layerrule = [
      "blur, layername:waybar"
    ];
  };
}
