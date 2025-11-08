{
  config,
  lib,
  pkgs,
  ...
}:
let
  awg0Port = 18181;
  awg0InterfaceName = "awg0";
  enabled = false;
  kernel = config.boot.kernelPackages;
in
{

  boot.extraModulePackages =
    (lib.optional (lib.versionOlder kernel.kernel.version "5.6") kernel.wireguard)
    ++ [ kernel.amneziawg ];
  boot.kernelModules = [
    "wireguard"
    "amneziawg"
  ];
  environment.systemPackages = with pkgs; [
    wireguard-tools
    amneziawg-tools
  ];

  networking.wireguard = {
    enable = true;

    interfaces.${awg0InterfaceName} = lib.mkIf enabled {
      type = "amneziawg";
      ips = [
        "10.100.1.1/24"
        "feee:10:100:1::1/64"
      ];
      listenPort = awg0Port;

      privateKeyFile = config.age.secrets.awg0-private.path;

      peers = [
        {
          # asgard
          publicKey = "A1OhUnq294z9cL7AptS2xtMOhPNyRSZO+1DOp9TJ5mU=";
          allowedIPs = [
            "10.100.1.2/32"
            "feee:10:100:1::2/128"
          ];
        }
        #{
        #  # hrafn
        #  publicKey = "x8wbb3bFWd0loNBA/I8025rSEwXdYVhR1dkFFZ4X/Wc=";
        #  allowedIPs = [
        #    "10.100.1.5/32"
        #    "feee:10:100:1::5/128"
        #  ];
        #}
      ];

      # we do not believe in lies
      extraOptions = {
        # https://github.com/amnezia-vpn/amneziawg-linux-kernel-module/tree/master?tab=readme-ov-file#configuration
        # this options doesn't work without amneziawg kernel module
        Jc = 4;
        Jmin = 50;
        Jmax = 1000;
        S1 = 51;
        S2 = 134;
        H1 = 1535652805;
        H2 = 1100194781;
        H3 = 2138938547;
        H4 = 1671852050;
      };
    };
  };

  networking.nftables = lib.mkIf (config.networking.wireguard.interfaces ? awg0InterfaceName) {
    firewall.rules.open-ports-uplink = {
      allowedUDPPorts = [
        awg0Port
      ];
    };

    chains.forward.forward-wireguard = {
      after = [ "early" ];
      before = [ "late" ];
      rules = [
        "iifname ${awg0InterfaceName} oifname uplink accept"
        "iifname uplink oifname ${awg0InterfaceName} accept"
      ];
    };

    chains.postrouting.uplink-masquerade = {
      after = [ "early" ];
      before = [ "late" ];
      rules = [ "oifname uplink masquerade" ];
    };
  };

  age.secrets.awg0-private.generator.script = "wireguard-priv";
}
