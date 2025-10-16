{ lib, config, ... }:
let
  cfg = config.services.netbird;
in
{
  services.netbird = {
    enable = true;

    clients.nukdokplex = {
      # ui.enable is enabled only on hosts with graphics session installed by default
      hardened = false;
      port = 51820;
      openFirewall = true;

      environment = {
        NB_ADMIN_URL = "https://netbird.nukdokplex.ru";
        NB_MANAGEMENT_URL = "https://netbird.nukdokplex.ru";
        NB_ENABLE_ROSENPASS = "false";
        NB_ROSENPASS_PERMISSIVE = "true";
      };
    };
  };

  networking.nftables.firewall.zones.trusted.interfaces = [
    "nb-nukdokplex"
  ];

  networking.nftables.firewall.rules = lib.mkIf cfg.enable (
    cfg.clients
    |> lib.filterAttrs (_: v: v.openFirewall)
    |> lib.mapAttrsToList (_: v: v.port)
    |> (ports: {
      open-ports-uplink.allowedUDPPorts = ports;
      open-ports-trusted.allowedUDPPorts = ports;
    })
  );

  networking.nftables.chains.forward.netbird = {
    after = [ "conntrack" ];
    before = [ "drop" ];
    rules = lib.singleton {
      text = ''iifname "${config.services.netbird.clients.nukdokplex.interface}" counter accept'';
    };
  };
}
