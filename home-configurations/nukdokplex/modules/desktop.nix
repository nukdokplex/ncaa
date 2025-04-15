{ pkgs, lib, config, ... }: {
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
      claws-mail
      font-manager
      gimp
      shotwell
    ]; 
    programs = {
      firefox.enable = true;
      spicetify = {
        enable = true;
        enableCustomConfiguration = true;
      };
      foot.enable = true;
    };
    services = {
      syncthing.enable = true;
    };
  };
}
