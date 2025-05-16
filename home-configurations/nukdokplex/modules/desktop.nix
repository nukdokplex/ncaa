{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.home.isDesktop {
    # there we add only desktop stuff
    home.packages = with pkgs; [
      onlyoffice-desktopeditors
      vesktop
      keepassxc
      ayugram-desktop
      qbittorrent
      vlc
      tor-browser
      chromium
      font-manager
      gimp
      shotwell
      yubioath-flutter
    ];
    services = {
      syncthing.enable = true;
    };
  };
}
