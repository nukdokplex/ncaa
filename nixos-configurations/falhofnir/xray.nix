{ lib, config, ... }:
let
  clients = [
    "sleipnir"
    "hrafn"
    "gladr"
    "holl"
    "babushbant"
    "asgard-router"
  ];
  port = {
    vless-xhttp-in = 777;
    vless-reality-in = 888;
    whoami-in = 8449;
    nginx-vless-xhttp-internal = 8443;
    nginx-vless-reality-intermediary = 444;
    nginx-vless-xhttp-intermediary = 445;
  };
in
{
  services.xray = {
    enable = false;
    settings = {
      version = {
        min = "25.10.15";
      };
      log = {
        loglevel = "debug";
        dnsLog = true;
      };
      dns = {
        servers = [
          "https://1.1.1.1/dns-query"
          "8.8.8.8"
        ];
      };
      routing = {
        domainStrategy = "IPOnDemand";
        rules = [
          #{
          #  inboundTag = [
          #    "vless-xhttp-in"
          #    "vless-reality-in"
          #  ];
          #  protocol = [ "bittorrent" ];
          #  outboundTag = "block-out";
          #}
          #{
          #  inboundTag = [
          #    "vless-xhttp-in"
          #    "vless-reality-in"
          #  ];
          #  ip = [
          #    "geoip:ru"
          #    "geoip:by"
          #    "geoip:kz"
          #    "geoip:cn"
          #  ];
          #  outboundTag = "block-out";
          #}
          {
            inboundTag = [
              "vless-xhttp-in"
              "vless-reality-in"
            ];
            outboundTag = "direct-out";
          }
        ];
      };
      outbounds = [
        {
          protocol = "freedom";
          tag = "direct-out";
        }
        {
          protocol = "blackhole";
          tag = "block-out";
        }
      ];
      inbounds = [
        {
          tag = "vless-xhttp-in";
          listen = "127.0.0.1";
          port = port.vless-xhttp-in;
          protocol = "vless";
          settings = {
            clients =
              clients
              |> map (client: {
                id._secret = config.age.secrets."xray-${client}-vless-uuid".path;
                # flow = "xtls-rprx-vision";
              });
            decryption = "none";
          };
          streamSettings = {
            network = "xhttp";
            xhttpSettings = {
              mode = "auto";
              path = "/a0ca93ce078d";
            };
            security = "reality";

          };
          sniffing = {
            enabled = true;
            routeOnly = true;
            destOverride = [
              "quic"
              "http"
              "tls"
            ];
          };
        }
        {
          tag = "vless-reality-in";
          listen = "127.0.0.1";
          port = port.vless-reality-in;
          protocol = "vless";
          settings = {
            clients =
              clients
              |> map (client: {
                id._secret = config.age.secrets."xray-${client}-vless-uuid".path;
                # flow = "xtls-rprx-vision";
              });
            decryption = "none";
            fallbacks = [
              {
                name = "creativecloud.adobe.com";
                dest = "creativecloud.adobe.com:443";
              }
            ];
          };
          streamSettings = {
            network = "grpc";
            security = "reality";
            realitySettings = {
              serverNames = [ "creativecloud.adobe.com" ];
              target = "creativecloud.adobe.com:443";
              privateKey._secret = config.age.secrets.xray-vless-reality-private-key.path;
              shortIds = [ { _secret = config.age.secrets.xray-vless-reality-short-id.path; } ];
            };
            grpcSettings = {
              serviceName = "";
            };
          };
          sniffing = {
            enabled = true;
            routeOnly = true;
            destOverride = [
              "quic"
              "http"
              "tls"
            ];
          };
        }
      ];
    };
  };

  age.secrets =
    (
      clients
      |> map (client: {
        "xray-${client}-vless-uuid".generator.script = "uuid";
      })
      |> lib.mergeAttrsList
    )
    // {
      xray-vlessenc = {
        generator.script = { pkgs, lib, ... }: ''${lib.getExe pkgs.xray} vlessenc'';
        intermediary = true;
      };
      #xray-vlessenc-nopqc-decryption.generator = {
      #  dependencies.vlessenc = config.age.secrets.xray-vlessenc;
      #  script = { pkgs, lib, decrypt, deps, ... }: ''
      #    ${decrypt} ${lib.escapeShellArg deps.vlessenc.file} | \
      #      grep "Authentication: X25519, not Post-Quantum" -A2 | \
      #      grep "decryption" | \
      #      awk -F': ' '{ print $2 }' | \
      #      sed 's/^"//; s/"$//'
      #  '';
      #};
      #xray-vlessenc-nopqc-encryption.generator = {
      #  dependencies.vlessenc = config.age.secrets.xray-vlessenc;
      #  script = { pkgs, lib, decrypt, deps, ... }: ''
      #    ${decrypt} ${lib.escapeShellArg deps.vlessenc.file} | \
      #      grep "Authentication: X25519, not Post-Quantum" -A2 | \
      #      grep "encryption" | \
      #      awk -F': ' '{ print $2 }' | \
      #      sed 's/^"//; s/"$//'
      #  '';
      #};
      xray-vlessenc-pqc-decryption.generator = {
        dependencies.vlessenc = config.age.secrets.xray-vlessenc;
        script =
          {
            lib,
            decrypt,
            deps,
            ...
          }:
          ''
            ${decrypt} ${lib.escapeShellArg deps.vlessenc.file} | \
              grep "Authentication: ML-KEM-768, Post-Quantum" -A2 | \
              grep "decryption" | \
              awk -F': ' '{ print $2 }' | \
              sed 's/^"//; s/"$//'
          '';
      };
      xray-vlessenc-pqc-encryption.generator = {
        dependencies.vlessenc = config.age.secrets.xray-vlessenc;
        script =
          {
            lib,
            decrypt,
            deps,
            ...
          }:
          ''
            ${decrypt} ${lib.escapeShellArg deps.vlessenc.file} | \
              grep "Authentication: ML-KEM-768, Post-Quantum" -A2 | \
              grep "encryption" | \
              awk -F': ' '{ print $2 }' | \
              sed 's/^"//; s/"$//'
          '';
      };
      xray-vless-reality-keypair = {
        intermediary = true;
        generator.script =
          { lib, pkgs, ... }:
          ''
            ${lib.getExe pkgs.xray} x25519
          '';
      };
      xray-vless-reality-private-key = {
        generator = {
          dependencies = {
            keypair = config.age.secrets.xray-vless-reality-keypair;
          };
          script =
            {
              lib,
              decrypt,
              deps,
              ...
            }:
            ''
              ${decrypt} ${lib.escapeShellArg deps.keypair.file} | \
                grep "PrivateKey" | \
                awk -F': ' '{ print $2 }'
            '';
        };
      };
      xray-vless-reality-password = {
        generator = {
          dependencies = {
            keypair = config.age.secrets.xray-vless-reality-keypair;
          };
          script =
            {
              lib,
              decrypt,
              deps,
              ...
            }:
            ''
              ${decrypt} ${lib.escapeShellArg deps.keypair.file} | \
                grep "Password" | \
                awk -F': ' '{ print $2 }'
            '';
        };
      };
      xray-vless-reality-hash32 = {
        intermediary = true;
        generator = {
          dependencies = {
            keypair = config.age.secrets.xray-vless-reality-keypair;
          };
          script =
            {
              lib,
              decrypt,
              deps,
              ...
            }:
            ''
              ${decrypt} ${lib.escapeShellArg deps.keypair.file} | \
                grep "Password" | \
                awk -F': ' '{ print $2 }'
            '';
        };
      };
      xray-vless-reality-short-id = {
        generator.script =
          { lib, pkgs, ... }:
          ''
            ${lib.getExe pkgs.openssl} rand -hex 8
          '';
      };
    };

  # networking.nftables.firewall.rules.open-ports-uplink = {
  #   allowedTCPPorts = [ 443 ];
  #   allowedUDPPorts = [ 443 ];
  # };
}
