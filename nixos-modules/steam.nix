{ pkgs, lib, config, ... }:
let
  cfg = config.programs.steam;
in
{
  options.programs.steam.enableCustomConfiguration = lib.mkEnableOption "custom Steam configuration";

  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    programs.steam = {
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraPackages = with pkgs; [
        libgudev
        libvdpau
        libsoup_2_4
        libusb1
        speex
        SDL2
        openal
        libglvnd
        gtk3
        mono
        dbus
      ];

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-cpp;
      extraRules = [
        {
          "name" = "gamescope";
          "nice" = -20;
        }
      ];
    };
  };
}
