{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.sing-box;
in
{
  imports = [ ./dnscrypt.nix ];
  options.services.sing-box.proxy-selector = {
    outbounds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    default = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = {
    services.sing-box = {
      enable = true;
      settings = {
        log = {
          disabled = false;
          level = "debug";
        };
        dns = {
          servers = [
            {
              tag = "resolved";
              type = "udp";
              server = "127.0.0.53";
              server_port = 53;
            }
          ];
          final = "resolved";
          disable_cache = true;
        };
        inbounds = [
          {
            tag = "mixed";
            type = "mixed";
            listen = "127.0.0.1";
            listen_port = 9900;
          }
          {
            tag = "mixed-all-proxy";
            type = "mixed";
            listen = "127.0.0.1";
            listen_port = 9901;
          }
        ];
        outbounds = [
          {
            tag = "proxy";
            type = "selector";
            inherit (cfg.proxy-selector) outbounds default;
            interrupt_exist_connections = true;
          }
          {
            tag = "direct";
            type = "direct";
          }
        ];
        route = {
          rules = [
            { action = "sniff"; }
            {
              ip_is_private = true;
              outbound = "direct";
            }
            {
              inbound = [ "mixed-all-proxy" ];
              outbound = "proxy";
            }
            {
              rule_set = [ "geosite-category-ru" ];
              outbound = "direct";
            }
          ];
          rule_set = [
            {
              type = "remote";
              tag = "geosite-category-ru";
              format = "binary";
              url = "https://github.com/SagerNet/sing-geosite/raw/refs/heads/rule-set/geosite-category-ru.srs";
              download_detour = "proxy";
            }
          ];
          default_domain_resolver = "resolved";
          auto_detect_interface = true;
          final = "proxy";
        };
      };
    };

    environment = {
      etc = {
        "tsocks.conf".text = ''
          # this is default tsocks config pointing to sing-box' mixed-all-proxy inbound
          server = 127.0.0.1
          server_port = 9901
          server_type = 5

          local = 10.0.0.0/255.0.0.0
          local = 100.64.0.0/255.192.0.0
          local = 127.0.0.0/255.0.0.0
          local = 169.254.0.0/255.255.0.0
          local = 172.16.0.0/255.240.0.0
          local = 192.168.0.0/255.255.0.0
        '';

        "proxychains.conf".text = ''
          strict_chain
          #proxy_dns
          #proxy_dns_old
          #proxy_dns_daemon 127.0.0.1:1053

          localnet 10.0.0.0/255.0.0.0
          localnet 100.64.0.0/255.192.0.0
          localnet 127.0.0.0/255.0.0.0
          localnet 169.254.0.0/255.255.0.0
          localnet 172.16.0.0/255.240.0.0
          localnet 192.168.0.0/255.255.0.0

          localnet ::1/128
          localnet fc00::/7
          localnet 200::/7

          [ProxyList]
          socks5  127.0.0.1 9901
        '';
      };

      systemPackages = with pkgs; [
        tsocks
        proxychains-ng
      ];
    };
  };
}
