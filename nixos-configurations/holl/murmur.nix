{
  config,
  lib,
  pkgs,
  ...
}:
let
  domain = "mumble.nukdokplex.ru";
  cfg = config.services.murmur;
  sslcfg = config.security.acme.certs.${domain};
in
{
  services.murmur = {
    enable = true;
    port = 59054;
    openFirewall = false;
    password = "$MURMUR_PASSWORD";
    environmentFile = config.age.secrets.murmur-env.path;
    bandwidth = 156000;
    sslKey = "${sslcfg.directory}/key.pem";
    sslCert = "${sslcfg.directory}/cert.pem";
    clientCertRequired = true;
  };

  networking.nftables.firewall.rules.open-ports-uplink = {
    allowedUDPPorts = [ cfg.port ];
    allowedTCPPorts = [ cfg.port ];
  };

  services.nginx.virtualHosts.mumble = {
    forceSSL = true;
    enableACME = true;
    serverName = domain;
  };

  security.acme.certs.${domain} = {
    # give murmur service user permission to ssl key with acl
    postRun = "${lib.getExe' pkgs.acl "setfacl"} --recursive --modify u:${cfg.user}:rX ${sslcfg.directory}";

    reloadServices = [ "murmur.service" ];
  };

  age.secrets = {
    murmur-password = {
      intermediary = true;
      generator.script = "strong-password";
    };

    murmur-env = {
      owner = cfg.user;
      inherit (cfg) group;
      mode = "0400";
      generator = {
        dependencies.password = config.age.secrets.murmur-password;
        script =
          {
            lib,
            decrypt,
            deps,
            ...
          }:
          ''
            cat << EOF
            MURMUR_PASSWORD="$(${decrypt} ${lib.escapeShellArg deps.password.file})"
            EOF
          '';
      };
    };
  };
}
