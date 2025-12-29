{ config, lib, ... }:
let
  webmailDomains = [
    "webmail.nukdokplex.ru"
    "webmail.nukdotcom.ru"
    "webmail.teanin.shop"
  ];
in
{
  services = {
    roundcube = {
      enable = true;
      configureNginx = true;
      hostName = lib.elemAt webmailDomains 0;
      extraConfig = ''
        $config['imap_host'] = "ssl://${config.mailserver.fqdn}";
        $config['smtp_host'] = "ssl://${config.mailserver.fqdn}";
        $config['smtp_user'] = "%u";
        $config['smtp_pass'] = "%p";
      '';

      # module is ensuring postgresql user and db by default
      # also it uses unix socket connection by default so it is really nice
      # lol it is really suckless nixos module
    };

    nginx.virtualHosts.${config.services.roundcube.hostName} = {
      serverName = lib.elemAt webmailDomains 0;
      forceSSL = true;
      enableACME = true;
      serverAliases = lib.sublist 1 (lib.length webmailDomains) webmailDomains;
    };
  };
}
