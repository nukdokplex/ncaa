{
  config,
  lib,
  pkgs,
  ...
}:
let
  hy2-out-listen-port = 1199;
in
{
  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "hysteria2";
          tag = "hy2-out";
          listen = "::";
          listen_port = hy2-out-listen-port;
          up_mbps = 500;
          down_mbps = 500;
          obfs = {
            type = "salamander";
            password._secret = config.age.secrets.sing-box-hy2-out-obfs-password.path;
          };
          users = [
            {
              name = "asgard";
              password._secret = config.age.secrets.sing-box-hy2-out-asgard-password.path;
            }
          ];
          ignore_client_bandwidth = false;
          tls = {
            enabled = true;
            server_name = "jugger.fannybaws.ru";
            key_path = "${config.security.acme.certs."jugger.fannybaws.ru".directory}/key.pem";
            certificate_path = "${config.security.acme.certs."jugger.fannybaws.ru".directory}/fullchain.pem";
          };
        }
      ];
    };
  };

  networking.nftables.firewall.rules.open-ports-uplink.allowedUDPPorts = [
    hy2-out-listen-port
  ];

  services.nginx.virtualHosts."jugger.fannybaws.ru" = {
    enableACME = true;
    # addSSL = true;
  };

  security.acme.certs."jugger.fannybaws.ru" = {
    reloadServices = [ "sing-box.service" ];
    postRun = "${lib.getExe' pkgs.acl "setfacl"} --recursive --modify u:sing-box:rX ${
      config.security.acme.certs."jugger.fannybaws.ru".directory
    }";
  };

  age.secrets = {
    sing-box-hy2-out-obfs-password = {
      generator.script = "strong-password";
    };

    sing-box-hy2-out-asgard-password = {
      generator.script = "strong-password";
    };
  };
}
