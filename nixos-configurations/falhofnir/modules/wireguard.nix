{ config, flakeRoot, pkgs, lib, ... }: let
  awg0Port = 18181;
  awg0InterfaceName = "awg0";
  uplink = "enx" + (lib.toLower (builtins.replaceStrings [ ":" ] [ "" ] config.systemd.network.networks.uplink.matchConfig.MACAddress));
in {
  networking.firewall.allowedUDPPorts = [ awg0Port ];
  networking.nat.internalInterfaces = [ awg0InterfaceName ];

  networking.wireguard = {
    enable = true;

    interfaces.${awg0InterfaceName} = {
      type = "amneziawg";
      ips = [ "10.100.1.1/24" "fe80:10:100:1::1/64" ];
      listenPort = awg0Port;
      
      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        '${lib.getExe' pkgs.iptables "iptables"}'  -t nat -A POSTROUTING -s 10.100.1.0/24 -o ${uplink} -j MASQUERADE
        '${lib.getExe' pkgs.iptables "ip6tables"}' -t nat -A POSTROUTING -s fe80:10:100:1::/64 -o ${uplink} -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        '${lib.getExe' pkgs.iptables "iptables"}'  -t nat -D POSTROUTING -s 10.100.1.0/24 -o ${uplink} -j MASQUERADE
        '${lib.getExe' pkgs.iptables "ip6tables"}' -t nat -D POSTROUTING -s fe80:10:100:1::/64 -o ${uplink} -j MASQUERADE
      '';

      privateKeyFile = config.age.secrets.awg0-private.path;

      peers = [
        {
          # yggdrasils
          publicKey = "we1V/v3wsZzZknibdQVPyxgMoCgVPvt/5bD2UEoHgVc=";
          allowedIPs = [ "10.100.1.2/32" "fe80:10:100:1::2/128" ];
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
