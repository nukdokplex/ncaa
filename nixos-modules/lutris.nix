{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.lutris;
in
{
  options.programs.lutris = {
    enable = lib.mkEnableOption "Lutris, an open-source gaming platform";
    enableCustomConfiguration = lib.mkEnableOption "custom Lutris configuration";
  };

  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    environment.systemPackages = [
      (pkgs.lutris.override {
        steamSupport = false;
        extraLibraries = pkgs: with pkgs; [ ];
        extraPkgs =
          pkgs: with pkgs; [
            wineWowPackages.stableFull
            libgudev
            libvdpau
            libsoup_2_4
            libusb1
            speex
          ];
      })
    ];
  };
}
