{
  config,
  flakeRoot,
  inputs,
  lib,
  ...
}:
let
  multicastPort = 9001;
  tlsPort = 36950;
  quicPort = 36951;
  yggdrasilPeers =
    inputs.self.outputs.nixosConfigurations
    |> lib.filterAttrs (hostName: _: (hostName != config.networking.hostName))
    |> lib.filterAttrs (_: host: host.config ? age.secrets.yggdrasil-private-key);
  yggdrasilPeersAddresses = [
    "200:f97:930b:75fa:5c23:b41f:5ff5:dee0"
  ]
  ++ (
    yggdrasilPeers
    |> lib.mapAttrsToList (
      _: host: builtins.readFile (host.config.age.rekey.generatedSecretsDir + /yggdrasil-address)
    )
  );
in
{
  services.yggdrasil = {
    enable = true;
    openMulticastPort = false;
    settings = {
      Listen = [
        { _secret = config.age.secrets.yggdrasil-quic-listen.path; }
        { _secret = config.age.secrets.yggdrasil-tls-listen.path; }
      ];
      PrivateKey._secret = config.age.secrets.yggdrasil-private-key.path;
      MulticastInterfaces = [
        {
          Regex = "uplink.*";
          Beacon = true;
          Listen = true;
          Password._secret = config.age.secrets.yggdrasil-multicast-password.path;
          Priority = 100;
        }
      ];
      IfName = "ygg0";
      IfMTU = 65535;
      NodeInfoPrivacy = false;
    };
  };

  networking.nftables.firewall = {
    rules = {
      open-ports-uplink = {
        allowedTCPPorts = [
          tlsPort
        ];
        allowedUDPPorts = [
          multicastPort
          quicPort
        ];
      };
    };
    zones = {
      yggdrasil = {
        enable = true;
        interfaces = [ "ygg0" ];
      };
      yggdrasil-peers = {
        enable = true;
        parent = "yggdrasil";
        ipv6Addresses = yggdrasilPeersAddresses |> map (address: "${address}/128");
      };
    };
  };

  age.secrets = {
    yggdrasil-multicast-password = {
      rekeyFile = flakeRoot + /secrets/generated/common/yggdrasil-multicast-password.age;
      generator = {
        tags = [ "yggdrasil" ];
        script = "strong-password";
      };
    };

    yggdrasil-password = {
      intermediary = true;
      generator = {
        tags = [ "yggdrasil" ];
        script = "strong-password";
      };
    };

    yggdrasil-tls-listen = {
      generator = {
        tags = [ "yggdrasil" ];
        dependencies.password = config.age.secrets.yggdrasil-password;
        script =
          {
            lib,
            decrypt,
            deps,
            ...
          }:
          ''
            PASSWORD="$(${decrypt} ${lib.escapeShellArg deps.password.file})"
            echo "tls://[::]:${toString tlsPort}?password=$PASSWORD"
          '';
      };
    };

    yggdrasil-quic-listen = {
      generator = {
        tags = [ "yggdrasil" ];
        dependencies.password = config.age.secrets.yggdrasil-password;
        script =
          {
            lib,
            decrypt,
            deps,
            ...
          }:
          ''
            PASSWORD="$(${decrypt} ${lib.escapeShellArg deps.password.file})"
            echo "quic://[::]:${toString quicPort}?password=$PASSWORD"
          '';
      };
    };

    yggdrasil-private-key = {
      generator = {
        tags = [
          "yggdrasil"
          config.networking.hostName
        ];
        script =
          {
            lib,
            pkgs,
            file,
            ...
          }:
          let
            addressFile = (lib.removeSuffix "private-key.age" file) + "address";
            publicKeyFile = (lib.removeSuffix "private-key.age" file) + "public-key";
          in
          ''
            # generate config with private key
            CONFIG="$(${lib.getExe' pkgs.yggdrasil "yggdrasil"} -genconf)"

            # calculate address associated with private key
            echo "$CONFIG" | ${lib.getExe' pkgs.yggdrasil "yggdrasil"} -useconf -address > ${lib.escapeShellArg addressFile}

            # calculate public key associated with private key
            echo "$CONFIG" | ${lib.getExe' pkgs.yggdrasil "yggdrasil"} -useconf -publickey > ${lib.escapeShellArg publicKeyFile}

            # extract private key from config
            echo "$CONFIG" | ${lib.getExe pkgs.hjson} -c | ${lib.getExe pkgs.jq} -r '.PrivateKey'
          '';
      };
    };
  };
}
