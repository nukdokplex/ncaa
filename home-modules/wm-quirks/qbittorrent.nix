t:
{ ... }:
t {
  name = "qbittorrent";
  humanName = "qBittorrent";

  config.wayland.windowManager = {
    hyprland.settings.windowrulev2 = [
      "float, class:org.qbittorrrent.qBittorrent, title:negative:(qBittorrent)(.*)"
    ];

    sway.extraConfig = ''
      for_window [app_id="org.qbittorrrent.qBittorrent" title="^(?!qBittorrent$).*"] floating enable
    '';
  };
}
