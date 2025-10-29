{ config, lib, ... }:
let
  domain = "sso.nukdokplex.ru";
  internalPort = 61533;
in
{
  services.zitadel = {
    enable = true;
    tlsMode = "external";
    masterKeyFile = config.age.secrets.zitadel-master-key.path;
    settings = {
      Telemetry.Enabled = false;

      ExternalDomain = domain;
      ExternalPort = 443;
      ExternalSecure = true;

      Port = internalPort;

      Database.postgres = {
        Host = "/var/run/postgresql/";
        Port = 5432;
        Database = "zitadel";
        User = {
          Username = "zitadel";
          SSL.Mode = "disable";
        };
        Admin = {
          Username = "zitadel";
          SSL.Mode = "disable";
          ExistingDatabase = "zitadel";
        };
      };
    };
    steps.FirstInstance = {
      InstanceName = "${config.networking.hostName}-zitadel";
      Org = {
        Name = "ZITADEL";
        Human = {
          UserName = "admin";
          FirstName = "Viktor";
          LastName = "Titov";
          NickName = "nukdokplex";
          DisplayName = "nukdokplex";
          Email.Address = "admin@nukdokplex.ru";
          Email.Verified = true;
          Password = "aSR?UAWS+VEPHLk7X5wNj7ZJmam2n*Ec";
          PasswordChangeRequired = true;
        };
      };
      LoginPolicy.AllowRegister = false;
    };
  };

  systemd.services.zitadel = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.postgresql = {
    ensureUsers = lib.singleton {
      name = "zitadel";
      ensureDBOwnership = true;
      ensureClauses = {
        login = true;
        superuser = true;
      };
    };

    ensureDatabases = lib.singleton "zitadel";
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/".extraConfig = ''
      grpc_pass grpc://[::1]:${toString internalPort};
      grpc_set_header Host $host;
      grpc_set_header X-Forwarded-Proto https;
    '';
    locations."/ui/v2/login".extraConfig = ''
      proxy_pass http://[::1]:${toString internalPort};
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-Proto https;
    '';
  };

  age.secrets.zitadel-master-key = {
    owner = "zitadel";
    group = "zitadel";
    mode = "0400";
    generator.script = "zitadel-master-key";
  };
}
