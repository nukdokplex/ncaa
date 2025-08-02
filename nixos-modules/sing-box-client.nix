{
  config,
  lib,
  inputs,
  flakeRoot,
  ...
}:
let
  falhofnir = inputs.self.nixosConfigurations.falhofnir.config;
in
{
  imports = [ ./dnscrypt.nix ];

  services.sing-box = {
    enable = lib.mkDefault true;
    # there is template to pin sing-box version
    # package = pkgs.sing-box.overrideAttrs (
    #   final: prev: {
    #     version = "1.12.0-beta.18";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "SagerNet";
    #       repo = "sing-box";
    #       tag = "v${final.version}";
    #       hash = "sha256-R42+v/1TpnRJrGtftJjee4N+1W5BIK9JEC6UPZerXUw=";
    #     };
    #     vendorHash = "sha256-5AWJB5uckIKrYD+r9C7TfYQNBcz1gGkBNIOQelpahXQ=";
    #     tags = [
    #       "with_gvisor"
    #       "with_quic"
    #       "with_dhcp"
    #       "with_wireguard"
    #       "with_utls"
    #       "with_acme"
    #       "with_clash_api"
    #       "with_tailscale"
    #     ];
    #   }
    # );
    settings = {
      log = {
        level = "debug";
        timestamp = false;
      };

      inbounds = [
        {
          type = "tun";
          tag = "tun-in";
          interface_name = "sing-box";

          address = [
            "172.18.0.1/30"
            "fdfe:dcba:9876::1/126"
          ];

          mtu = 65535;
          auto_route = true;
          auto_redirect = true;
          strict_route = false;

          stack = "mixed";

          route_address = [
            "0.0.0.0/1"
            "128.0.0.0/1"
            "::/1"
            "8000::/1"
          ];

          route_exclude_address = [
            # ipv6 private networks
            "200::/7" # yggdrasil
            "fc00::/7"
            # ipv4 private networks
            "192.168.0.0/16"
            "127.0.0.0/8"
            "10.0.0.0/8"
            "172.16.0.0/12"
          ];
        }
      ];

      outbounds = [
        {
          tag = "direct-out";
          type = "direct";
        }
        {
          tag = "proxy-out";
          type = "vless";

          server = "${falhofnir.networking.hostName}.nukdokplex.ru";
          server_port = 3000;

          domain_strategy = "prefer_ipv4";

          uuid._secret = config.age.secrets.sing-box-vless-uuid.path;

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
              short_id._secret = config.age.secrets.sing-box-vless-short-id.path;
            };
          };

          multiplex = {
            enabled = false;
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
      dns = {
        servers = [
          {
            tag = "google";
            address = "tcp://8.8.8.8";
            detour = "direct-out";
          }
          {
            tag = "cloudflare";
            address = "tcp://1.1.1.1";
            detour = "direct-out";
          }
          {
            tag = "local-dnscrypt";
            address = "udp://[::1]:53";
            detour = "direct-out";
          }
        ];
        final = "local-dnscrypt";
        disable_cache = true; # we don't need dns cache since we use dnscrypt-proxy2
        strategy = "prefer_ipv6";
      };

      route = {
        rules = [
          {
            port = 53;
            action = "hijack-dns";
          }
          {
            ip_is_private = true;
            outbound = "direct-out";
          }
          { action = "sniff"; }
          {
            # my own list
            domain_suffix = [
              "myip.com" # that one is just to test if proxy is working
              "sing-box-sagernet.org" # sing-box docs, expected to be blocked some time
              "paheal.net" # not present it lists for some reason
            ];
            outbound = "proxy-out";
          }
          {
            rule_set = [
              "ru-bundle"
              "discord-voice-ip-list"
            ];
            outbound = "proxy-out";
          }
        ];
        rule_set = [
          {
            tag = "ru-bundle";
            type = "remote";
            format = "binary";
            url = "https://github.com/legiz-ru/sb-rule-sets/raw/main/ru-bundle.srs";
            download_detour = "proxy-out";
            update_interval = "168h0m0s";
          }
          {
            tag = "discord-voice-ip-list";
            type = "remote";
            format = "binary";
            url = "https://github.com/legiz-ru/sb-rule-sets/raw/main/discord-voice-ip-list.srs";
            download_detour = "proxy-out";
            update_interval = "168h0m0s";
          }
        ];
        final = "direct-out";
        auto_detect_interface = true;
      };
    };
  };

  age.secrets.sing-box-vless-uuid.rekeyFile =
    flakeRoot
    + /secrets/generated/falhofnir/sing-box-vless-in-${config.networking.hostName}-uuid.age;
  age.secrets.sing-box-vless-short-id.rekeyFile =
    flakeRoot
    + /secrets/generated/falhofnir/sing-box-vless-in-reality-short-id.age;
}
