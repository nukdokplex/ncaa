{ lib, ... }:
{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;

    settings = {
      log_connections = true;
      log_statement = "all";
      logging_collector = true;
      log_disconnections = true;
      log_destination = lib.mkForce "syslog";
      port = 5432;
    };

    authentication = ''
      # TYPE  DATABASE  USER  ADDRESS  METHOD
      local   all       all            ident
      host    all       all   all      scram-sha-256
    '';
  };
}
