{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.lutris-bwrapped;

  lutris = pkgs.lutris.override {
    steamSupport = true;
    extraPkgs =
      pkgs: with pkgs; [
        wineWowPackages.stableFull
        winetricks
        libgudev
        libvdpau
        libusb1
        speex
      ];
  };

  lutris-bwrapped = pkgs.mkBwrapper {
    app = {
      package = lutris;
      isFhsenv = true;
      id = "net.lutris.Lutris";
      env = {
        WEBKIT_DISABLE_DMABUF_RENDERER = 1;
        APPIMAGE_EXTRACT_AND_RUN = 1;
      };
    };
    fhsenv = {
      skipExtraInstallCmds = false;
    };
    dbus = {
      session = {
        talks = [
          "org.freedesktop.Flatpak"
          "org.kde.StatusNotifierWatcher"
          "org.kde.KWin"
          "org.gnome.Mutter.DisplayConfig"
          "org.freedesktop.ScreenSaver"
        ];
        owns = [
          "net.lutris.Lutris"
        ];
      };
      system = {
        talks = [
          "org.freedesktop.UDisks2"
        ];
      };
    };
    mounts = lib.mkMerge [
      {
        read = [
          "$HOME/.config/kdedefaults"
          "$HOME/.local/share/color-schemes"
          "/run/systemd/resolve/stub-resolv.conf" # https://github.com/Naxdy/nix-bwrapper/issues/23
        ];
        readWrite = [
          "$HOME/.steam"
          "$HOME/.local/share/steam"
          "$HOME/.local/share/applications"
          "$HOME/.local/share/desktop-directories"
          "$HOME/Games"
        ];
      }
      cfg.extraMounts
    ];
  };
in
{
  options.programs.lutris-bwrapped = {
    extraMounts = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
    };
  };

  config.environment.systemPackages = [ lutris-bwrapped ];
}
