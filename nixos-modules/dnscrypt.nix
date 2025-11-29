{ lib, ... }:
{
  services.dnscrypt-proxy = {
    enable = true;
    upstreamDefaults = true;
    settings = {
      listen_addresses = [ "127.0.0.69:53" ];

      bootstrap_resolvers = [
        # opendns (excluded from hijacking in dnscrypt settings
        "208.67.222.222:53"
        "208.67.220.220:53"
        "[2620:0:ccc::2]:53"
        "[2620:0:ccd::2]:53"

        # yandex dns, also excluded
        "77.88.8.8:53"
        "77.88.8.1:53"
        "[2a02:6b8::feed:0ff]:53"
        "[2a02:6b8:0:1::feed:0ff]:53"
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

  networking.nameservers = [ "127.0.0.69" ];
  services.resolved.fallbackDns = lib.mkBefore [ "127.0.0.69" ];
}
