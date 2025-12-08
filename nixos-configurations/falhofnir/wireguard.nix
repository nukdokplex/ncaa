{ config, ... }:
{
  networking.wireguard = {
    enable = true;

    interfaces.awg = {
      type = "amneziawg";
      ips = [
        "10.14.56.1/24"
        "feee:10:1456::1/64"
      ];

      listenPort = 53018;

      privateKeyFile = config.age.secrets.awg-private.path;

      peers = [
        {
          # asgard
          publicKey = "hZSZYf+30IXVy8W0QHiuiVuEJG197MaS90ddQzZiuy0=";
          allowedIPs = [
            "10.14.56.2/32"
            "feee:10:1456::2/128"
          ];
        }
      ];

      # we do not believe in lies
      extraOptions = {
        # https://github.com/amnezia-vpn/amneziawg-linux-kernel-module/tree/master?tab=readme-ov-file#configuration
        # this options doesn't work without amneziawg kernel module
        Jc = 4;
        Jmin = 8;
        Jmax = 80;
        S1 = 44;
        S2 = 122;
        # next values were generated fairly with "shuf -i 5-2147483647 -n 4"
        H1 = 1160144433;
        H2 = 224432528;
        H3 = 669506316;
        H4 = 32742131;
      };
    };
  };

  networking.nftables = {
    firewall = {
      zones.awg.interfaces = [ "awg" ];

      rules = {
        open-ports-awg = {
          from = [ "awg" ];
          to = [ config.networking.nftables.firewall.localZoneName ];
          allowedUDPPorts = [
            21061 # socks
          ];
          allowedTCPPorts = [
            21061 # socks
          ];
        };

        open-ports-uplink = {
          allowedUDPPorts = [
            config.networking.wireguard.interfaces.awg.listenPort
          ];
        };
      };
    };

    chains.forward.forward-wireguard = {
      after = [ "early" ];
      before = [ "late" ];
      rules = [
        "iifname awg oifname uplink accept"
        "iifname uplink oifname awg accept"
      ];
    };

    chains.postrouting.uplink-masquerade = {
      after = [ "early" ];
      before = [ "late" ];
      rules = [ "oifname uplink masquerade" ];
    };
  };

  age.secrets.awg-private.generator.script = "wireguard-priv";
}
