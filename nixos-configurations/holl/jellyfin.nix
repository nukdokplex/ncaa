{ pkgs, config, ... }:
let
  domain = "jellyfin.nukdokplex.ru";
in
{

  services.jellyfin = {
    enable = true;
    openFirewall = false;
    user = "nukdokplex";
    logDir = "/var/log/jellyfin";
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  security.acme.certs.jellyfin = { inherit domain; };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    sslCertificate = "${config.security.acme.certs.jellyfin.directory}/cert.pem";
    sslCertificateKey = "${config.security.acme.certs.jellyfin.directory}/key.pem";
    locations."/" = {
      proxyPass = "http://[::1]:8096";
      proxyWebsockets = true;
    };
  };

  services.fail2ban.jails = {
    jellyfin.settings = {
      enabled = true;
      backend = "auto";
      port = "80,443";
      protocol = "tcp";
      filter = "jellyfin";
      maxretry = 5;
      bantime = 60 * 60 * 6; # 6 hours
      findtime = 60 * 10; # 10 minutes
      logpath = "/var/log/jellyfin/log_*.log";
    };
  };

  environment.etc."fail2ban/filter.d/jellyfin.conf".text = ''
    [Definition]
    failregex = ^.*Authentication request for .* has been denied \(IP: "<ADDR>"\)\.
  '';
}
