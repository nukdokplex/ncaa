{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.steam;
in
{
  options.programs.steam.enableCustomConfiguration = lib.mkEnableOption "custom Steam configuration";

  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    networking.nftables.tables.filter.content = ''
      chain post_input_hook {
        tcp dport { 27036, 27015, 27040 } counter accept comment "Accept Steam TCP ports"
        udp dport { 27036, 27031-27035, 27015 } counter accept comment "Accept Steam UDP ports"
      }
    '';

    programs.steam = {
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
