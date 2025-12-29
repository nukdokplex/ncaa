{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  hysteria2-listen-port = 1199;
  moduleEnabledHostConfigs =
    inputs.self.outputs.nixosConfigurations
    |> lib.filterAttrs (hostName: _: hostName != config.networking.hostName)
    |> lib.filterAttrs (_: host: host.config ? age.secrets.falhofnir-hysteria2-user-password)
    |> lib.mapAttrs (_: host: host.config);
in
{
  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "hysteria2";
          tag = "hysteria2";
          listen = "::";
          listen_port = hysteria2-listen-port;
          up_mbps = 500;
          down_mbps = 500;
          obfs = {
            type = "salamander";
            password._secret = config.age.secrets.hysteria2-obfs-password.path;
          };
          users = [
            {
              name = "asgard";
              password._secret = config.age.secrets.hysteria2-asgard-password.path;
            }
          ]
          ++ (
            moduleEnabledHostConfigs
            |> lib.mapAttrsToList (
              hostName: _: {
                name = hostName;
                password._secret = config.age.secrets."hysteria2-${hostName}-password".path;
              }
            )
          );
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

  networking.nftables.firewall.rules.open-ports-uplink.allowedUDPPorts = [ hysteria2-listen-port ];

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
    hysteria2-obfs-password = {
      generator.script = "strong-password";
      owner = "sing-box";
      group = "sing-box";
    };

    hysteria2-asgard-password = {
      generator.script = "strong-password";
      owner = "sing-box";
      group = "sing-box";
    };
  }
  // (
    moduleEnabledHostConfigs
    |> lib.mapAttrs' (
      hostName: cfg: {
        name = "hysteria2-${hostName}-password";
        value = {
          inherit (cfg.age.secrets.falhofnir-hysteria2-user-password) rekeyFile;
          owner = "sing-box";
          group = "sing-box";
        };
      }
    )
  );
}
