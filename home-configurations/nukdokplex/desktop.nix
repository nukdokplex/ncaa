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
        ayugram-desktop # alternative telegram client
        chromium # web browser
        fluffychat # matrix client
        font-manager # simple gtk font manager
        galculator # gtk calculator
        gimp # linux photoshop
        keepassxc # password manager
        kid3 # id3 tag editor
        mumble # voice chat
        onlyoffice-desktopeditors # office programs
        openpgp-card-tools # work with opengpg cards (picokeys, yubikeys, etc.)
        qbittorrent # torrent client
        scrcpy # android remote desktop over adb
        shotwell # image viewer
        supersonic-wayland # subsonic music player
        tor-browser # tor browser
        vlc # media player
        wine64Packages.stagingFull # wine packages
        winetricks # Script to install DLLs needed to work around problems in Wine
        yubioath-flutter # gui tool to manage yubikeys
      ]
      ++ lib.optional (
        pkgs.stdenv.hostPlatform.system == "x86_64-linux"
      ) inputs.picokeys-nix.packages.x86_64-linux.pico-fido-tool; # tool to manage pico-fido(2) keys

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vaapi
        obs-pipewire-audio-capture
      ];
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    home.sessionVariables = {
      GTK_USE_PORTAL = "1";
      NIXOS_XDG_OPEN_USE_PORTAL = "1";
    };
  };
}
