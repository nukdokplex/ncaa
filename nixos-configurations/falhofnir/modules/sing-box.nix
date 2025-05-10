{
  lib,
  config,
  inputs,
  ...
}:
let
  vlessPort = 3000;
  vlessExcludeHostNames = [ "gler" ];
  vlessHostNames =
    builtins.filter (
      hostName:
      (!builtins.elem hostName vlessExcludeHostNames) && (hostName != config.networking.hostName)
    ) (builtins.attrNames inputs.self.outputs.nixosConfigurations)
    ++ [
      "hrafn"
      "babushbant"
    ];
in
{
  networking.firewall.interfaces.uplink.allowedTCPPorts = [ vlessPort ];

  services.sing-box = {
    enable = true;
    settings = {
      log = {
        level = "debug";
      };
      dns = {
        servers = [
          {
            tag = "local";
            address = "local";
          }
        ];
        final = "local";
        strategy = "prefer_ipv6";
      };
      inbounds = [
        (lib.fix (vless-in: {
          type = "vless";
          tag = "vless-in";

          listen = "::"; # v4 will also work
          listen_port = vlessPort;

          users = builtins.map (hostName: {
            name = hostName;
            uuid = {
              _secret = config.age.secrets."sing-box-vless-in-${hostName}-uuid".path;
            };
            flow = "xtls-rprx-vision";
          }) vlessHostNames;

          transport = {
            type = "ws";
            path = "/account/0/services/cloud/getContents";

            headers = {
              Host = vless-in.tls.server_name;
            };
          };

          tls = {
            enabled = true;
            server_name = "creativecloud.adobe.com";
            reality = {
              enabled = true;
              handshake = {
                server = vless-in.tls.server_name;
                server_port = 443;
              };
              private_key = {
                _secret = config.age.secrets.sing-box-vless-in-reality-private-key.path;
              };
              short_id = [ { _secret = config.age.secrets.sing-box-vless-in-reality-short-id.path; } ];
            };
          };

          multiplex = {
            enabled = true;
            padding = false;
            brutal.enabled = false;
          };
        }))
      ];
    };
  };

  age.secrets =
    {
      sing-box-vless-in-reality-private-key.generator.script = "reality-keypair";
      sing-box-vless-in-reality-short-id.generator.script = "reality-short-id";
    }
    // builtins.listToAttrs (
      builtins.map (
        hostName: lib.nameValuePair "sing-box-vless-in-${hostName}-uuid" { generator.script = "uuid"; }
      ) vlessHostNames
    );
}
