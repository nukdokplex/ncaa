{ pkgs, lib, config, ... }: let
  ifName = "ovpn-tun";
  port = 1194;
in {
  networking.firewall.allowedTCPPorts = [ 1194 ]; # allow input port
}
