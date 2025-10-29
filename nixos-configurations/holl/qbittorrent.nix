{ config, lib, ... }:
let
  cfg = config.services.qbittorrent;
  domain = rec {
    root = "nukdokplex.ru";
    qbittorrent = "torrent.${root}";
  };
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

  services.oauth2-proxy.nginx.virtualHosts.torrent.allowed_groups = [
    "343961069196171270:admin"
    "343961069196171270:torrent"
  ];
  services.nginx.virtualHosts.torrent = {
    serverName = domain.qbittorrent;
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString cfg.webuiPort}";
      proxyWebsockets = true;
    };
  };

  networking.nftables.firewall.rules = lib.mkIf (cfg.enable && cfg.openFirewall) {
    open-ports-uplink.allowedTCPPorts = [ cfg.torrentingPort ];
    # open-ports-trusted.allowedTCPPorts = [ cfg.webuiPort ];
  };
}
