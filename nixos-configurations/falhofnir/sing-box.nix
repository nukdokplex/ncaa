{
  lib,
  config,
  ...
}:
let
  clients = [
    "sleipnir"
    "gladr"
    "holl"
    "hrafn"
    "babushbant"
    "asgard-router"
  ];
in
{

  services.sing-box = {
    enable = true;
    settings = {
      log = {
        level = "debug";
      };
      dns = {
        servers = [
          {
            tag = "local";
            address = "local";
          }
        ];
        final = "local";
        strategy = "prefer_ipv6";
      };

      route = {
        final = "direct-out";
        auto_detect_interface = true;
      };

      outbounds = [
        {
          tag = "direct-out";
          type = "direct";
        }
      ];

      inbounds = [
        {
          tag = "trojan-in";
          type = "trojan";

          listen = "::";
          listen_port = 443;

          users = map (name: {
            inherit name;
            password._secret = config.age.secrets."${name}-trojan-password".path;
          }) clients;

          tls = {
            enabled = true;
            server_name = "falhofnir.nukdokplex.ru";
            certificate_path = "${config.security.acme.certs.${config.networking.hostName}.directory}/cert.pem";
            key_path = "${config.security.acme.certs.${config.networking.hostName}.directory}/key.pem";
          };

          multiplex = {
            enabled = true;
            padding = true;
          };

          transport = {
            type = "http";
            path = "/configuration/shared/update_client";
            method = "POST";
          };

        }
        {
          tag = "hy2-in";
          type = "hysteria2";

          listen = "::";
          listen_port = 8443;

          obfs = {
            type = "salamander";
            password._secret = config.age.secrets.hysteria2-obfs-salamander-password.path;
          };

          users = builtins.map (name: {
            inherit name;
            password._secret = config.age.secrets."${name}-hysteria2-password".path;
          }) clients;

          ignore_client_bandwidth = true;
          tls = {
            enabled = true;
            server_name = "falhofnir.nukdokplex.ru";
            certificate_path = "${config.security.acme.certs.${config.networking.hostName}.directory}/cert.pem";
            key_path = "${config.security.acme.certs.${config.networking.hostName}.directory}/key.pem";
          };
          brutal_debug = true;
        }
        # {
        #   type = "vless";
        #   tag = "vless-in";

        #   listen = "::"; # v4 will also work
        #   listen_port = vlessPort;

        #   users = builtins.map (hostName: {
        #     name = hostName;
        #     uuid = {
        #       _secret = config.age.secrets."sing-box-vless-in-${hostName}-uuid".path;
        #     };
        #     flow = "xtls-rprx-vision";
        #   }) vlessHostNames;

        #   transport = {
        #     type = "ws";
        #     path = "/home/devices/eafbbf25-cd56-450d-9b3d-1d25ffd716a7/transfer";
        #     early_data_header_name = "Sec-WebSocket-Protocol";
        #   };

        #   tls = {
        #     enabled = true;
        #     server_name = "www.pcloud.com";
        #     reality = {
        #       enabled = true;
        #       handshake = {
        #         server = "www.pcloud.com";
        #         server_port = 443;
        #         detour = "direct-out";
        #       };
        #       private_key._secret = config.age.secrets.sing-box-vless-in-reality-private-key.path;
        #       short_id = [ { _secret = config.age.secrets.sing-box-vless-in-reality-short-id.path; } ];
        #     };
        #   };

        #   multiplex = {
        #     enabled = false;
        #     padding = false;
        #     brutal.enabled = false;
        #   };
        # }
      ];
    };
  };

  users.users.sing-box.extraGroups = [ "acme" ];

  networking.nftables.firewall.rules.open-ports-uplink = lib.mkIf config.services.sing-box.enable {
    allowedTCPPorts = [
      443
      8443
    ];
    allowedUDPPorts = [
      443
      8443
    ];
  };

  age.secrets = {
    sing-box-vless-in-reality-private-key.generator.script = "reality-keypair";
    sing-box-vless-in-reality-short-id.generator.script = "reality-short-id";
    hysteria2-obfs-salamander-password.generator.script = "strong-password";

  }
  // builtins.listToAttrs (
    builtins.map (
      hostName:
      lib.nameValuePair "${hostName}-trojan-password" {
        generator.script = "strong-password";
        owner = "sing-box";
        group = "sing-box";
        mode = "440";
      }
    ) clients
  )
  // builtins.listToAttrs (
    builtins.map (
      hostName:
      lib.nameValuePair "${hostName}-hysteria2-password" {
        generator.script = "strong-password";
        owner = "sing-box";
        group = "sing-box";
        mode = "440";
      }
    ) clients
  );
}
