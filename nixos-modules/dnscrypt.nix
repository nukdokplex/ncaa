{ lib, pkgs, ... }:
{
  services.dnscrypt-proxy2 = {
    enable = true;
    upstreamDefaults = true;
    settings = {
      listen_addresses = [
        "127.0.0.1:53"
        "[::1]:53"
      ];

      bootstrap_resolvers = [
        # yandex dns
        "77.88.8.8:53"
        "77.88.8.1:53"
      ];
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 73;
        prefix = "";
      };

      sources.dnscry-pt-resolvers = {
        urls = [ "https://www.dnscry.pt/resolvers.md" ];
        minisign_key = "RWQM31Nwkqh01x88SvrBL8djp1NH56Rb4mKLHz16K7qsXgEomnDv6ziQ";
        cache_file = "dnscry.pt-resolvers.md";
        refresh_delay = 72;
        prefix = "dnscry.pt-";
      };
    };
  };
}
