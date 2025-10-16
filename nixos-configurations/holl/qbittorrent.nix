{ config, lib, ... }:
let
  cfg = config.services.qbittorrent;
in
{
  services.qbittorrent = {
    enable = true;

    user = "nukdokplex";
    group = "users";

    profileDir = "/data/downloads/torrents/.qbittorrent";

    openFirewall = false;
    webuiPort = 46055;
    torrentingPort = cfg.webuiPort + 1;
  };

  networking.nftables.firewall.rules = lib.mkIf (cfg.enable && cfg.openFirewall) {
    open-ports-uplink.allowedTCPPorts = [ cfg.torrentingPort ];
    open-ports-trusted.allowedTCPPorts = [ cfg.webuiPort ];
  };
}
