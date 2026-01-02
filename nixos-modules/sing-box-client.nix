{
  config,
  lib,
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
              type = "resolved";
              tag = "resolved";
              service = "resolved";
              accept_default_resolvers = false;
            }
            {
              tag = "dnscrypt";
              type = "udp";
              server = "127.0.0.69";
              server_port = 53;
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
        };
        services = [
          {
            tag = "resolved";
            type = "resolved";
            listen = "127.0.0.53";
            listen_port = 53;
          }
        ];
        inbounds = [
          {
            type = "tun";
            tag = "tun";
            interface_name = "sing-box";
            address = [
              "172.18.0.1/30"
              "fdfe:dcba:9876::1/126"
            ];
            stack = "system";
            mtu = 9000;
            auto_redirect = true;
            auto_route = true;
            strict_route = true;
            route_address = [
              "0.0.0.0/0"
              "::/0"
            ];
            route_exclude_address = [
              "10.0.0.0/8" # private network
              "100.64.0.0/10" # private network
              "169.254.0.0/16" # link-local
              "172.16.0.0/12" # private network
              "192.0.0.0/24" # private network
              "192.168.0.0/16" # private network
              "fc00::/7" # private network
              "200::/7" # yggdrasil
            ];
            exclude_uid = with config.users.users; [
              dnscrypt-proxy.uid
            ];
          }
          {
            tag = "mixed";
            type = "mixed";
            listen = "::1";
            listen_port = 9000;
          }
          {
            tag = "mixed-no-proxy";
            type = "mixed";
            listen = "::1";
            listen_port = 9900;
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
            {
              inbound = [ "mixed-no-proxy" ];
              action = "route";
              outbound = "direct";
            }
            {
              port = 53;
              action = "hijack-dns";
            }
            { action = "sniff"; }
            {
              inbound = [ "mixed" ];
              action = "route";
              outbound = "proxy";
            }
            {
              protocol = [
                "bittorrent"
                "ssh"
                "rdp"
                "ntp"
              ];
              action = "route";
              outbound = "direct";
            }
            {
              domain_suffix = [
                "cache.nixos.org"
                "cachix.org"
              ];
              action = "route";
              outbound = "direct";
            }
            {
              domain_suffix = [
                "googleapis.com"
                "gstatic.com"
                "myip.com"
                "nixos.org"
                "sagernet.org"
              ];
              action = "route";
              outbound = "proxy";
            }
            {
              rule_set = "ru-bundle";
              action = "route";
              outbound = "proxy";
            }
            {
              rule_set = "discord-voice-ip-list";
              port_range = [ "50000:50030" ];
              port = [
                80
                443
              ];
              action = "route";
              outbound = "proxy";
            }
            {
              ip_is_private = true;
              action = "route";
              outbound = "direct";
            }
          ];
          rule_set = [
            {
              tag = "ru-bundle";
              type = "remote";
              format = "source";
              url = "https://raw.githubusercontent.com/legiz-ru/sb-rule-sets/refs/heads/main/ru-bundle.json";
              download_detour = "proxy";
            }
            {
              tag = "discord-voice-ip-list";
              type = "remote";
              format = "source";
              url = "https://raw.githubusercontent.com/legiz-ru/sb-rule-sets/refs/heads/main/discord-voice-ip-list.json";
              download_detour = "proxy";
            }
          ];
          default_domain_resolver = "dnscrypt";
          auto_detect_interface = true;
          final = "direct";
          # final = "proxy";
        };
      };
    };

    systemd.services = {
      systemd-resolved = {
        wantedBy = lib.mkForce [ ];
        conflicts = [ "sing-box.service" ];
      };

      sing-box = {
        conflicts = [ "systemd-resolved.service" ];
      };
    };
  };

}
