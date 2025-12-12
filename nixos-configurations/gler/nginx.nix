{ ... }:
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedUwsgiSettings = true;
    recommendedBrotliSettings = true;
  };

  networking.nftables.firewall.rules.open-ports-uplink.allowedTCPPorts = [
    80
    443
  ];
}
