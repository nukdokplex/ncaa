t:
{ ... }:
t {
  name = "steam";
  humanName = "Steam";

  config.wayland.windowManager = {
    hyprland.settings.windowrulev2 = [
      "float, class:steam, initialTitle:negative:^(Steam)$"
    ];

    sway.extraConfig = ''
      for_window [app_id="steam" title="^(?!Steam$).*"] floating enable
    '';
  };
}
