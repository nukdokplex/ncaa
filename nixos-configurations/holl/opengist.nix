{ config, lib, ... }:
let
  domain = "gist.nukdokplex.ru";
  webPort = 6157;
  sshPort = 2222;
in
{
  virtualisation.oci-containers.containers = {
    opengist = {
      image = "ghcr.io/thomiceli/opengist:1.10";
      ports = [
        "${toString webPort}:6157"
        "${toString sshPort}:2222"
      ];
      volumes = [ "/var/lib/opengist/data:/opengist" ];
      environment = {
        OG_LOG_OUTPUT = "stdout";
        OG_EXTERNAL_URL = "https://gist.nukdokplex.ru";
        OG_INDEX = "bleve";
        OG_GIT_DEFAULT_BRANCH = "master";
        OG_HTTP_HOST = "[::]";
        OG_HTTP_GIT_ENABLED = "false";
        OG_SSH_HOST = "[::]";
        OG_CUSTOM_NAME = "NukDokGist";
        OG_CUSTOM_STATIC_LINK_0_NAME = "NukDokPlex";
        OG_CUSTOM_STATIC_LINK_0_PATH = "https://nukdokplex.ru";
        OG_CUSTOM_STATIC_LINK_1_NAME = "GitHub";
        OG_CUSTOM_STATIC_LINK_1_PATH = "https://github.com/nukdokplex";
        OG_CUSTOM_STATIC_LINK_2_NAME = "Telegram";
        OG_CUSTOM_STATIC_LINK_2_PATH = "https://t.me/nukdokplex";
      };
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://127.0.0.1:${toString webPort}";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/opengist/data 0750 root root - -"
    "f /var/lib/opengist/config.yml 0750 root root - -"
  ];

  networking.nftables.firewall.rules =
    lib.mkIf (config.virtualisation.oci-containers.containers ? "opengist")
      {
        open-ports-trusted.allowedTCPPorts = [ sshPort ];
      };
}
