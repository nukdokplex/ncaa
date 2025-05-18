{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  config = lib.mkIf config.home.isDesktop {
    # there we add only desktop stuff
    home.packages =
      with pkgs;
      [
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

        # hw keys
        yubioath-flutter
        openpgp-card-tools
      ]
      ++ lib.optional (
        pkgs.system == "x86_64-linux"
      ) inputs.picokeys-nix.packages.x86_64-linux.pico-fido-tool;

    services = {
      syncthing.enable = true;
    };
  };
}
