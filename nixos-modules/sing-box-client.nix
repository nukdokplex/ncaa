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
          {
            tag = "local";
            type = "udp";
            server = "127.0.0.69";
            server_port = 53;
          }
        ];

        final = "local";
        disable_cache = true;
      };
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

          stack = "mixed";

          route_address = [
            "0.0.0.0/1"
            "128.0.0.0/1"
            "::/1"
            "8000::/1"
          ];

          route_exclude_address = [
            "10.0.0.0/8"
            "172.16.0.0/12"
            "100.64.0.0/10"
            "127.0.0.1/8"
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
            server = "local";
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
        default_domain_resolver = "local";
        auto_detect_interface = true;
      };
    };
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
