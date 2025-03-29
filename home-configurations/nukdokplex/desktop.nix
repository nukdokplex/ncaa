{ pkgs, lib, osConfig, ... }: {
  config = lib.mkIf osConfig.common.desktop.enable {
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
      thunderbird
      font-manager
      gimp
      shotwell
    ]; 
    programs = {
      spicetify = {
        enable = true;
        enableCustomConfiguration = true;
      };
      wezterm = {
        enable = true;
        enableZshIntegration = true;
        extraConfig = ''
          return {
            window_background_opacity = 0.75,
            mux_enable_ssh_agent = false
          }
        '';
      };
    };
    services = {
      syncthing.enable = true;
      arrpc.enable = true;
    };
  };
}
