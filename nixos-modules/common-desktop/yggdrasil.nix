{
  lib,
  config,
  ...
}:
let
  cfg = config.services.yggdrasil;
in
{
  options.services.yggdrasil.openFirewall = lib.mkOption {
    type = lib.types.bool;
    description = "Whether to open firewall for yggdrasil connections";
    default = true;
  };

  config = {
    services.yggdrasil = lib.mkDefault {
      enable = true;
      configFile = config.age.secrets.yggdrasil.path;
      settings = {
        Listen = [
          "tcp://[::]:7991"
          "tls://[::]:7992"
          "quic://[::]:7993"
        ];
        MulticastInterfaces = [
          {
            Regex = "uplink.*";
            Beacon = true;
            Listen = true;
            Port = 7999;
            Priority = 100; # lower value is higher priority
          }
        ];
      };
    };

    age.secrets.yggdrasil = { };

    networking.nftables.tables.filter.content = lib.mkIf cfg.openFirewall ''
      chain post_input_hook {
        tcp dport { 7991, 7992, 7999 } counter accept
        udp dport 7993 counter accept
      }
    '';
  };
}
