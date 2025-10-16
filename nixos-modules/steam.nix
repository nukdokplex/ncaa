{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [
      libgudev
      libvdpau
      libusb1
      speex
      SDL2
      openal
      libglvnd
      gtk3
      mono
      dbus
    ];

    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;
  services.ananicy = lib.mkDefault {
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

  networking.nftables.firewall.rules.open-ports-trusted =
    let
      cfg = config.programs.steam;
    in
    lib.mkMerge [
      (lib.mkIf (cfg.remotePlay.openFirewall || cfg.localNetworkGameTransfers.openFirewall) {
        allowedUDPPorts = [ 27036 ]; # Peer discovery
      })

      (lib.mkIf cfg.remotePlay.openFirewall {
        allowedTCPPorts = [ 27036 ];
        allowedUDPPortRanges = [
          {
            from = 27031;
            to = 27035;
          }
        ];
      })

      (lib.mkIf cfg.dedicatedServer.openFirewall {
        allowedTCPPorts = [ 27015 ]; # SRCDS Rcon port
        allowedUDPPorts = [ 27015 ]; # Gameplay traffic
      })

      (lib.mkIf cfg.localNetworkGameTransfers.openFirewall {
        allowedTCPPorts = [ 27040 ]; # Data transfers
      })
    ];
}
