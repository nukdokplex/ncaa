{ config, ... }:
{
  services.qbittorrent = {
    enable = true;

    user = "nukdokplex";
    group = "users";

    profileDir = "/data/downloads/torrents/.qbittorrent";

    openFirewall = true;
    webuiPort = 46055;
    torrentingPort = config.services.qbittorrent.webuiPort + 1;
  };
}
