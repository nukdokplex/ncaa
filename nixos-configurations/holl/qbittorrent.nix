{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.qbittorrent;
  domain = rec {
    root = "nukdokplex.ru";
    qbittorrent = "torrent.${root}";
  };

  # set this script to run after torrent downloaded
  # after-download-script "%N" "%L" "%G" "%F" "%R" "%D" "%C" "%Z" "%T" "%I" "%J" "%K"
  afterDownloadScript = pkgs.writeShellScriptBin "after-download-script" ''
    #! ${pkgs.runtimeShell}
    LOGFILE="/tmp/qbittorrent-after-download.log"

    exec > "$LOGFILE" 2>&1

    set -x

    torrent_name="$1"
    category="$2"
    tags="$3"
    folder="$4"
    root_folder="$5"
    save_folder="$6"
    file_count="$7"
    torrent_size_bytes="$8"
    current_tracker="$9"
    hash_v1="$10"
    hash_v2="$11"
    torrent_id="$12"

    # echo all vars
    set

    if [[ "$category" == "lidarr" ]]; then
      cd "$folder"
      ${lib.getExe pkgs.unflac}
    fi
  '';
in
{
  services.qbittorrent = {
    enable = true;
    openFirewall = false;
    webuiPort = 46055;
    torrentingPort = cfg.webuiPort + 1;
  };

  systemd.services.qbittorrent.path = [ afterDownloadScript ];

  users.users.qbittorrent.extraGroups = [
    "torrent"
    "music"
  ];

  services.oauth2-proxy.nginx.virtualHosts.torrent.allowed_groups = [
    "343961069196171270:admin"
    "343961069196171270:manage_torrents"
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
