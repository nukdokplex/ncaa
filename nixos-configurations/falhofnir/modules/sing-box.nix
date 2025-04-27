{ lib, flakeRoot, pkgs, config, ... }: let
  vlessPort = 8443;
in {
  networking.firewall.interfaces.uplink.allowedTCPPorts = [ vlessPort ];

  services.sing-box = {
    enable = true;
    settings = {
      log = { };
      dns = {
        servers = [
          {
            type = "local";
            tag = "local";
          }
        ];
        final = "local";
        strategy = "prefer_ipv6";
      };
      inbounds = [{
        type = "vless";
        tag = "vless-in";

        listen_port = vlessPort;

        users = [
          {
            name = "hrafn";
            uuid = { _secret = config.age.secrets.sing-box-hrafn-uuid.path; };
            flow = "xtls-rprx-vision";
          }
          {
            name = "babushbant";
            uuid = { _secret = config.age.secrets.sing-box-babushbant-uuid.path; };
            flow = "xtls-rprx-vision";
          }
        ];

        tls = lib.fix (tls: {
          enabled = true;
          server_name = "creativecloud.adobe.com";
          reality = {
            enabled = true;
            handshake = {
              server = tls.server_name;
              server_port = 443;
            };
            private_key = { _secret = config.age.secrets.sing-box-vless-in-reality-private-key; };
          };
        });
      }];
    };
  };

  age.secrets.sing-box-hrafn-uuid = {
    rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/sing-box-hrafn-uuid.age;
    generator.script = "uuid";
  };

  age.secrets.sing-box-babushbant-uuid = {
    rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/sing-box-babushbant-uuid.age;
    generator.script = "uuid";
  };

  age.secrets.sing-box-vless-in-reality-private-key = {
    rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/sing-box-vless-in-reality-private-key.age;
    generator.script = "reality-keypair";
  };
}
