{ config, ... }:
{
  virtualisation.oci-containers.containers."3x-ui" = {
    image = "ghcr.io/mhsanaei/3x-ui:latest";
    volumes = [
      "3x-ui-db:/etc/x-ui/"
      "${config.age.secrets.cdn-certificate.path}:/root/cert/cert.pem"
      "${config.age.secrets.cdn-private-key.path}:/root/cert/privkey.pem"
    ];

    environment = {
      XRAY_VMESS_AEAD_FORCED = "false";
      XUI_ENABLE_FAIL2BAN = "true";
    };

    extraOptions = [
      "--network=host"
      "--tty=true"
    ];
  };

  services.whoami = {
    enable = true;
    port = 8080;
  };

  services.nginx.virtualHosts.whoami = {
    serverName = "_";
    addSSL = true;
    sslCertificate = config.age.secrets.cdn-certificate.path;
    sslCertificateKey = config.age.secrets.cdn-private-key.path;
    listen = [
      {
        ssl = true;
        port = 444;
        addr = "0.0.0.0";
      }
    ];
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.whoami.port}";
      recommendedProxySettings = true;
    };
  };

  networking.nftables.firewall.rules.open-ports-uplink = {
    allowedTCPPorts = [
      2053 # dashboard
      46266 # xhttp
      444 # whoami
      443 # vless-reality
    ];
  };

  age.secrets = {
    cdn-certificate = {
      mode = "0444";
    };
    cdn-private-key = {
      mode = "0440";
      group = "nginx";
      owner = "root";
    };
  };
}
