{
  config,
  lib,
  flakeRoot,
  ...
}:
{
  imports = [ ./dnscrypt.nix ];

  services.sing-box = {
    enable = true;
    # package = pkgs.sing-box.overrideAttrs (
    #   final: prev: {
    #     version = "1.13.0-alpha.5";
    #     src = pkgs.fetchFromGitHub {
    #       owner = "SagerNet";
    #       repo = "sing-box";
    #       tag = "v${final.version}";
    #       hash = "sha256-5VXqkwBnOy8+yd4kZ4clZutqhiIpLKt0wtQG8DjyG3Q=";
    #     };
    #     vendorHash = "sha256-Y/UP2rbee4WSctelk9QddMXciucz5dNLOLDDWtEFfLU=";
    #     tags = [
    #       "with_gvisor"
    #       "with_quic"
    #       "with_dhcp"
    #       "with_wireguard"
    #       "with_utls"
    #       "with_acme"
    #       "with_clash_api"
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
            "192.168.0.0/16"
            "10.0.0.0/8"
            "172.16.0.0/12"
            "100.64.0.0/10"
            "200::/7"
            "fd00::/8"
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
          type = "trojan";

          server = "falhofnir.nukdokplex.ru";
          server_port = 443;

          domain_resolver = {
            server = "dnscrypt";
            domain_strategy = "prefer_ipv4";
          };

          password._secret = config.age.secrets.sing-box-trojan-password.path;

          tls.enabled = true;

          multiplex.enabled = false;

          transport = {
            type = "http";
            path = "/configuration/shared/update_client";
            method = "POST";
          };
        }
      ];

      dns = {
        servers = [
          {
            tag = "dnscrypt";
            type = "udp";
            server = "127.0.0.69";
            server_port = 53;
          }
          {
            tag = "resolved";
            type = "resolved";
            service = "resolved";
            accept_default_resolvers = false;
          }
        ];

        rules = [
          {
            domain_suffix = [ ".local" ];
            action = "route";
            server = "resolved";
          }
        ];

        final = "dnscrypt";
        disable_cache = true;
        strategy = "prefer_ipv6";
      };

      services = [
        {
          tag = "resolved";
          type = "resolved";

          listen = "127.0.0.53";
          listen_port = 53;
        }
      ];

      route = {
        rules = [
          {
            # rule to passthrough some dns requests
            ip_cidr = [
              # ns1.desec.io
              "45.54.76.1/32"
              "2607:f740:e633:deec::/64"

              # ns2.desec.org
              "157.53.224.1/32"
              "2607:f740:e00a:deec::/64"

              # opendns
              "208.67.222.222/32"
              "208.67.220.220/32"
              "2620:0:ccc::2/128"
              "2620:0:ccd::2/128"

              # yandex dns
              "77.88.8.8/32"
              "77.88.8.1/32"
              "2a02:6b8::feed:0ff/128"
              "2a02:6b8:0:1::feed:0ff/128"
            ];
            port = 53;
            action = "route";
            outbound = "direct-out";
          }
          {
            port = 53;
            action = "hijack-dns";
          }
          {
            ip_is_private = true;
            action = "route";
            outbound = "direct-out";
          }
          { action = "sniff"; }
          {
            # my own list
            domain_suffix = [
              "myip.com" # that one is just to test if proxy is working
              "sing-box.sagernet.org" # sing-box docs, expected to be blocked some time
              "paheal.net" # not present in lists for some reason
            ];
            action = "route";
            outbound = "proxy-out";
          }
          {
            rule_set = [
              "ru-bundle"
              "discord-voice-ip-list"
            ];
            action = "route";
            outbound = "proxy-out";
          }
        ];
        rule_set = [
          {
            tag = "ru-bundle";
            type = "remote";
            format = "binary";
            url = "https://github.com/legiz-ru/sb-rule-sets/raw/main/ru-bundle.srs";
            download_detour = "direct-out";
            update_interval = "168h0m0s";
          }
          {
            tag = "discord-voice-ip-list";
            type = "remote";
            format = "binary";
            url = "https://github.com/legiz-ru/sb-rule-sets/raw/main/discord-voice-ip-list.srs";
            download_detour = "direct-out";
            update_interval = "168h0m0s";
          }
        ];
        final = "direct-out";
        auto_detect_interface = true;
      };
    };
  };

  systemd.services = {
    sing-box.conflicts = [ "systemd-resolved.service" ];
    systemd-resolved.wantedBy = lib.mkForce [ ];
  };

  age.secrets.sing-box-trojan-password = {
    rekeyFile =
      flakeRoot
      + /secrets/generated/falhofnir/${config.networking.hostName}-trojan-password.age;
    owner = "sing-box";
    group = "sing-box";
    mode = "440";
  };
}
