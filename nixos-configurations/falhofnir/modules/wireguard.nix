{ config, flakeRoot, pkgs, lib, ... }: let
  awg0Port = 18181;
  awg0InterfaceName = "awg0";
  # uplink = "enx" + (lib.toLower (builtins.replaceStrings [ ":" ] [ "" ] config.systemd.network.networks.uplink.matchConfig.MACAddress));
in {
  networking.firewall.allowedUDPPorts = [ awg0Port ];
  networking.nat.internalInterfaces = [ awg0InterfaceName ];

  networking.wireguard = {
    enable = true;

    interfaces.${awg0InterfaceName} = {
      type = "amneziawg";
      ips = [ "10.100.1.1/24" "feee:10:100:1::1/64" ];
      listenPort = awg0Port;
      
      privateKeyFile = config.age.secrets.awg0-private.path;

      peers = [
        {
          # yggdrasils
          publicKey = "we1V/v3wsZzZknibdQVPyxgMoCgVPvt/5bD2UEoHgVc=";
          allowedIPs = [ "10.100.1.2/32" "feee:10:100:1::2/128" ];
        }
        {
          # hrafn
          publicKey = "x8wbb3bFWd0loNBA/I8025rSEwXdYVhR1dkFFZ4X/Wc=";
          allowedIPs = [ "10.100.1.5/32" "feee:10:100:1::5/128" ];
        }
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

  age.secrets.awg0-private = {
    rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/awg0-private.age;
    generator.script = "wireguard-priv";
  };
}
