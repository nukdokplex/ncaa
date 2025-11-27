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
    enable = true;
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
          {
            inboundTag = [
              "vless-xhttp-in"
              "vless-reality-in"
            ];
            protocol = [ "bittorrent" ];
            outboundTag = "block-out";
          }
          {
            inboundTag = [
              "vless-xhttp-in"
              "vless-reality-in"
            ];
            ip = [
              "geoip:ru"
              "geoip:by"
              "geoip:kz"
              "geoip:cn"
            ];
            outboundTag = "block-out";
          }
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
              mode = "stream-up";
              path = "/a0ca93ce078d";
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
          };
          streamSettings = {
            network = "raw";
            security = "reality";
            realitySettings = {
              dest = "creativecloud.adobe.com:443";
              serverNames = [ "creativecloud.adobe.com" ];
              privateKey._secret = config.age.secrets.xray-vless-reality-private-key.path;
              shortIds = [ { _secret = config.age.secrets.xray-vless-reality-short-id.path; } ];
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

  services.nginx = {
    enable = true;
    streamConfig = ''
      geo $remote_addr $is_cdn {
        default          0;

        173.245.48.0/20  1;
        103.21.244.0/22  1;
        103.22.200.0/22  1;
        103.31.4.0/22    1;
        141.101.64.0/18  1;
        108.162.192.0/18 1;
        190.93.240.0/20  1;
        188.114.96.0/20  1;
        197.234.240.0/22 1;
        198.41.128.0/17  1;
        162.158.0.0/15   1;
        104.16.0.0/13    1;
        104.24.0.0/14    1;
        172.64.0.0/13    1;
        131.0.72.0/22    1;

        2400:cb00::/32   1;
        2606:4700::/32   1;
        2803:f800::/32   1;
        2405:b500::/32   1;
        2405:8100::/32   1;
        2a06:98c0::/29   1;
        2c0f:f248::/32   1;
      }

      map $is_cdn $dest {
        0 127.0.0.1:${toString port.nginx-vless-reality-intermediary}; # tcp-vless-reality-vision direct
        1 127.0.0.1:${toString port.nginx-vless-xhttp-intermediary}; # xhttp-vless over cdn with cloak
      } 

      server { listen 443; proxy_pass $dest; }
      server { listen ${toString port.nginx-vless-reality-intermediary}; proxy_pass 127.0.0.1:${toString port.vless-reality-in}; }
      server { listen ${toString port.nginx-vless-xhttp-intermediary}; proxy_pass 127.0.0.1:${toString port.nginx-vless-xhttp-internal}; }
    '';

    virtualHosts.xray = {
      serverName = "fannybaws.ru";
      http2 = true;
      addSSL = true;
      sslCertificate = config.age.secrets.cdn-certificate.path;
      sslCertificateKey = config.age.secrets.cdn-private-key.path;
      listen = [
        {
          addr = "0.0.0.0";
          port = port.nginx-vless-xhttp-internal;
          ssl = true;
        }
      ];
      locations = {
        "/a0ca93ce078d" = {
          extraConfig = ''
            client_max_body_size 0;
            grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            grpc_pass grpc://127.0.0.1:${toString port.vless-xhttp-in};
          '';
        };
        "/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.whoami.port}";
          recommendedProxySettings = true;
        };
      };
    };
  };

  services.whoami = {
    enable = true;
    port = 8449;
    extraArgs = [
      "-name"
      config.networking.hostName
    ];
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
      cdn-certificate = {
        mode = "0444";
      };
      cdn-private-key = {
        owner = "nginx";
        group = "nginx";
        mode = "0400";
      };
    };

  networking.nftables.firewall.rules.open-ports-uplink = {
    allowedTCPPorts = [ 443 ];
    allowedUDPPorts = [ 443 ];
  };
}
