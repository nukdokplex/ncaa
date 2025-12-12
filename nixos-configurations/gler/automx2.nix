{ config, lib, ... }:
let
  cfg = config.services.automx2;
in
{
  services = {
    automx2 = {
      enable = true;
      domain = "nukdokplex.ru";
      settings = {
        provider = "nukdokplex";
        domains = [
          "nukdokplex.ru"
          "nukdotcom.ru"
          "teanin.shop"
        ];
        servers = [
          {
            type = "imap";
            name = "gler.nukdokplex.ru";
          }
          {
            type = "smtp";
            name = "gler.nukdokplex.ru";
          }
        ];
        proxy_count = 1;
      };
    };

    nginx.virtualHosts =
      let
        additionalDomains = cfg.settings.domains |> lib.remove cfg.domain;
        makeAlias = domain: {
          "autoconfig.${domain}" = {
            enableACME = true;
            forceSSL = true;
            serverAliases = [ "autodiscover.${domain}" ];
            locations = {
              "/".proxyPass = "http://127.0.0.1:${toString cfg.port}";
              "/initdb".extraConfig = ''
                # Limit access to clients connecting from localhost
                allow 127.0.0.1;
                deny all;
              '';
            };
          };
        };
      in
      additionalDomains |> map makeAlias |> lib.mkMerge;
  };
}
