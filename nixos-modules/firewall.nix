{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nixos-nftables-firewall.nixosModules.default ];
  networking.nftables.firewall = {
    enable = true;
    snippets = {
      nnf-common.enable = false;
      nnf-conntrack.enable = true;
      nnf-default-stopRuleset.enable = true;
      nnf-dhcpv6.enable = true;
      nnf-drop.enable = true;
      nnf-icmp = {
        enable = true;
        ipv4Types = [
          "echo-reply"
          "echo-request"
        ];
        ipv6Types = [
          "nd-router-solicit"
          "nd-router-advert"
          "nd-neighbor-solicit"
          "nd-neighbor-advert"
          "echo-request"
          "echo-reply"
        ];
      };
      nnf-loopback.enable = true;
      nnf-ssh.enable = true;
    };
    zones = {
      uplink = {
        interfaces = [
          "uplink"
          "uplink*"
        ];
      };
      trusted = {
        interfaces = lib.mkDefault [ "trustnoone" ];
      };
    };
    rules.open-ports-uplink = {
      from = [ "uplink" ];
      to = [ config.networking.nftables.firewall.localZoneName ];
      ignoreEmptyRule = true;
    };
    rules.open-ports-trusted = {
      from = [ "trusted" ];
      to = [ config.networking.nftables.firewall.localZoneName ];
      inherit (config.networking.nftables.firewall.rules.open-ports-uplink)
        allowedTCPPorts
        allowedUDPPorts
        allowedTCPPortRanges
        allowedUDPPortRanges
        ;
      ignoreEmptyRule = true;
    };
  };
}
