t:
{ ... }:
t {
  name = "network-manager-applet";
  humanName = "Network Manager applet";

  config.wayland.windowManager = {
    hyprland.settings.windowrulev2 = [
      "float, class:nm-connection-editor"
    ];

    sway.extraConfig = ''
      for_window [app_id="nm-connection-editor"] floating enable
    '';
  };
}
