{
  config,
  pkgs,
  lib,
  inputs,
  flakeRoot,
  ...
}:
let
  falhofnir = inputs.self.nixosConfigurations.falhofnir.config;
  dnscryPtTlsServer =
    bld:
    lib.fix (self: {
      tag = "dnscry-pt-${bld}";
      address = "tls://${bld}.dnscry.pt";
      address_resolver = "local";
      address_strategy = "prefer_ipv4";
    });
  removeCidr = range: builtins.head (lib.strings.splitString "/" range);
  vlessProxyDomain = "${falhofnir.networking.hostName}.nukdokplex.ru";
  vlessProxyAddress = removeCidr (
    lib.lists.findFirst (
      range: builtins.elem "." (lib.strings.stringToCharacters range)
    ) vlessProxyDomain falhofnir.systemd.network.networks.uplink.address
  );

in
{
  config.services.sing-box = {
    enable = lib.mkDefault true;
    settings = {
      log = {
        level = "debug";
        timestamp = false;
      };
      dns = {
        servers = [
          {
            tag = "local";
            address = "tcp://8.8.8.8:53";
          }
          # (dnscryPtTlsServer "mow01")
          # (dnscryPtTlsServer "ams01")
          # (dnscryPtTlsServer "ams02")
        ];
        final = "local";
        # rules = [
        #   {
        #     # ipv6 war crime
        #     ip_version = 6;
        #     domain = vlessProxyDomain;
        #     action = "predefined";
        #     answer = [ ]; # empty response
        #   }
        # ];
      };

      route = {
        rules = [
          {
            inbound = "tun-in";
            protocol = "dns";
            action = "hijack-dns";
          }
          {
            inbound = "tun-in";
            ip_is_private = true;
            outbound = "direct-out";
          }
          {
            inbound = "tun-in";
            action = "sniff";
            timeout = "1s";
          }
        ];
        final = "direct-out";
        auto_detect_interface = true;
      };

      inbounds = [
        {
          tag = "tun-in";
          type = "tun";
          auto_route = true;
          strict_route = true;
          address = [
            "172.18.0.1/30"
            "fdfe:dcba:9876::1/126"
          ];
          interface_name = "sing-box";
          stack = "system";
        }
      ];

      outbounds = [
        {
          tag = "direct-out";
          type = "direct";
        }
        {
          tag = "proxy-out";
          type = "selector";
          outbounds = [ "vless-out" ];
          default = "vless-out";
          interrupt_exist_connections = false;
        }
        {
          tag = "vless-out";
          type = "vless";
          server = vlessProxyAddress;
          server_port = 3000;
          uuid = {
            _secret = config.age.secrets.sing-box-vless-uuid.path;
          };
          flow = "xtls-rprx-vision";
          tls = {
            enabled = true;
            server_name = "creativecloud.adobe.com"; # aboba
            utls = {
              enabled = true;
              fingerprint = "firefox";
            };
            reality = {
              enabled = true;
              public_key = builtins.readFile (
                flakeRoot + /secrets/generated/falhofnir/sing-box-vless-in-reality-private-key.pub
              );
              short_id = {
                _secret = config.age.secrets.sing-box-vless-short-id.path;
              };
            };
          };
          multiplex = {
            enabled = true;
            protocol = "yamux";
            # TODO maybe other values?
            max_streams = 16;
          };
          transport = {
            type = "ws";
            path = "/account/0/services/cloud/getContents";
            headers.Host = "creativecloud.adobe.com";
          };
          packet_encoding = "xudp";
        }
      ];
    };
  };

  config.age.secrets.sing-box-vless-uuid.rekeyFile =
    flakeRoot + /secrets/generated/falhofnir/sing-box-vless-in-${config.networking.hostName}-uuid.age;
  config.age.secrets.sing-box-vless-short-id.rekeyFile =
    flakeRoot + /secrets/generated/falhofnir/sing-box-vless-in-reality-short-id.age;
}
