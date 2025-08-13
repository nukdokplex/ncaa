{
  services.qbittorrent = {
    enable = true;
    user = "nukdokplex";
    group = "users";
    openFirewall = true;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        WebUI = {
          Username = "nukdokplex";
          Password_PBKDF2 = "VdrVs3Y9qmZeyC5EH38rhA==:ROjakxON6+/jA5BG0FZbBdx90JGik1sCx87rFLQJpQcAsBd0QeFYc3W/TPgcSeSvo9EQ9su4NqZzginNgPe97w==";
        };
        General.Locale = "ru";
        BitTorrent = {
          Session = {
            DefaultSavePath = "/data/downloads/torrents";
            TempPath = "/data/downloads/torrents_incomplete";
            TempPathEnabled = true;
            TorrentExportDirectory = "/data/downloads/dot_torrent_files";
          };
        };
      };
    };
  };
}
