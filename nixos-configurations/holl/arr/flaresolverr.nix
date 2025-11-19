{ ... }:
{
  services = {
    flaresolverr = {
      enable = true;
      port = 52988;
      openFirewall = false;
    };
  };
}
