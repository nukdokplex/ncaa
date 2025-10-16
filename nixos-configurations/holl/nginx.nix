{ lib, config, ... }:
{
  services.nginx = {
    enable = true;

    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedUwsgiSettings = true;
  };

  networking.nftables.firewall.rules = lib.mkIf config.services.nginx.enable {
    open-ports-uplink.allowedTCPPorts = [
      80
      443
    ];
  };

  users.users.nginx.extraGroups = lib.singleton "acme";
}
