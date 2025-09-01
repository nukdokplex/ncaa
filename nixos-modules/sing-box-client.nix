{
  config,
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
      dns = {
        servers = [
          # {
          #   tag = "local";
          #   type = "local";
          #   # type = "udp";
          #   # server = "127.0.0.69";
          #   # server_port = 53;
          # }
          # {
          #   tag = "resolved";
          #   type = "resolved";
          #   accept_default_resolvers = true;
          #   service = "resolved";
          # }
          {
            tag = "dnscrypt";
            type = "udp";
            server = "127.0.0.69";
            server_port = 53;
            #detour = "direct-out";
          }
          {
            tag = "local";
            type = "udp";
            server = "127.0.0.53";
            server_port = 53;
          }
        ];
        rules = [
          {
            domain_suffix = [ "local" ];
            action = "route";
            server = "local";
          }
        ];

        final = "dnscrypt";
        disable_cache = true;
      };
      # services = lib.singleton {
      #   tag = "resolved";
      #   type = "resolved";
      #   listen = "127.0.0.53";
      #   listen_port = 53;
      # };
      inbounds = [
        {
          type = "tun";
          tag = "common-tun-in";
          interface_name = "sing-box-common";

          address = [
            "172.18.0.1/30"
            "fdfe:dcba:9876::1/126"
          ];

          mtu = 65535;
          auto_route = true;
          auto_redirect = true;
          strict_route = true;

          stack = "system";

          route_address = [
            "0.0.0.0/0"
            "::/0"
          ];

          route_exclude_address = [
            "10.0.0.0/8"
            "172.16.0.0/12"
            "100.64.0.0/10"
            "200::/7"
            "fd00::/8"
            "127.0.0.69/32"

            # ns1.desec.io
            "45.54.76.1/32"
            "2607:f740:e633:deec::2/128"

            # ns2.desec.org
            "157.53.224.1/32"
            "2607:f740:e00a:deec::2/128"

            # opendns and yandex dns are used as dnscrypt's bootstrap resolvers

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

      route = {
        rules = [
          { action = "sniff"; }
          {
            protocol = "dns";
            action = "hijack-dns";
          }
          {
            protocol = "bittorrent";
            action = "route";
            outbound = "direct-out";
          }
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
        default_domain_resolver = "dnscrypt";
        auto_detect_interface = true;
      };
    };
  };

  # environment.etc."resolv.conf".text = ''
  #   nameserver=8.8.8.8
  # '';

  # services.resolved.enable = lib.mkForce false;

  age.secrets.sing-box-trojan-password = {
    rekeyFile =
      flakeRoot
      + /secrets/generated/falhofnir/${config.networking.hostName}-trojan-password.age;
    owner = "sing-box";
    group = "sing-box";
    mode = "440";
  };
}
