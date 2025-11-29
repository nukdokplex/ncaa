{
  lib,
  pkgs,
  config,
  ...
}:
let
  domain = "sso.nukdokplex.ru";
in
{
  services = {
    keycloak = {
      enable = true;
      package = pkgs.keycloak.override {
        plugins = [
          (pkgs.fetchzip {
            name = "junixsocket";
            url = "https://github.com/kohlschutter/junixsocket/releases/download/junixsocket-2.10.1/junixsocket-dist-2.10.1-bin.tar.gz";
            hash = "sha256-GVw3rsYfABoTvx1QqxNfB8XXJkrvBZq5zTLU1/cl7XU=";
            downloadToTemp = true;
            postFetch = ''
              mv $out/lib tmp
              rm -r $out
              mv tmp $out
            '';
          })
        ];
      };

      database.createLocally = false;

      settings = {
        http-host = "127.0.0.1";
        http-port = 59284;
        http-enabled = true;
        proxy-headers = "xforwarded";
        hostname = domain;
        db = lib.mkForce "postgres";
        db-url = lib.mkForce "jdbc:postgresql:///keycloak?socketFactory=org.newsclub.net.unix.AFUNIXSocketFactory$FactoryArg&socketFactoryArg=/run/postgresql/.s.PGSQL.5432";

        # Disable defaults from the NixOS module.
        db-username = lib.mkForce null;
        db-password = lib.mkForce null;
        db-url-host = lib.mkForce null;
        db-url-port = lib.mkForce null;
        db-url-database = lib.mkForce null;
        db-url-properties = lib.mkForce null;

        bootstrap-admin-username = "temp-admin";
        bootstrap-admin-password = "aw759xSlKOd1SekotZdNESqB";
      };
    };

    postgresql = {
      ensureDatabases = lib.singleton "keycloak";
      ensureUsers = lib.singleton {
        name = "keycloak";
        ensureDBOwnership = true;
      };
    };

    nginx.virtualHosts.sso = {
      serverName = domain;
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.keycloak.settings.http-port}";
      };
    };
  };
}
