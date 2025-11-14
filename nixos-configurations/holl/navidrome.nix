{ config, lib, ... }:
let
  domain = "music.nukdokplex.ru";
  internalPort = 4533;
in
{
  services.navidrome = {
    enable = true;
    openFirewall = false;
    settings = {
      Address = "0.0.0.0";
      Port = internalPort;

      BaseUrl = "https://${domain}";

      ReverseProxyWhiteList = "::1/128,127.0.0.1/32";
      ReverseProxyUserHeader = "X-Preferred-Username";

      MusicFolder = "/data/downloads/music";
      "Scanner.PurgeMissing" = "always";
      "Tags.Artist.Split" = [
        " / "
        " feat. "
        " feat "
        " ft. "
        " ft "
        "; "
        ", "
      ];
      EnableSharing = true;
      DefaultShareExpiration = "${toString (24 * 7)}h";

      EnableInsightsCollector = false;
    };
  };

  users.users.nukdokplex.extraGroups = lib.singleton config.services.navidrome.group;

  services.oauth2-proxy.nginx.virtualHosts.music.allowed_groups = [
    "343961069196171270:admin"
    "343961069196171270:music"
  ];

  services.nginx.virtualHosts.music = {
    serverName = domain;
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.navidrome.settings.Port}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
          auth_request_set $preferred_username $upstream_http_x_auth_request_preferred_username;
          proxy_set_header X-Preferred-Username $preferred_username;
        '';
      };
      "/rest/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.navidrome.settings.Port}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
          auth_request off;
        '';
      };
      "/share/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.navidrome.settings.Port}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
          auth_request off;
        '';
      };
      "= /metrics".return = 403;
    };
  };
}
