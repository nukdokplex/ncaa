{ ezModules, ... }:
{
  imports = with ezModules; [
    via
    k3b-custom
    xray
    oauth2-proxy-nginx
    yggdrasil
  ];
}
