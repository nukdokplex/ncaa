{
  services.netbird = {
    enable = true;

    clients.nukdokplex = {
      # ui.enable is enabled only on hosts with graphics session installed by default
      hardened = false;
      openFirewall = true;
      port = 51820;

      environment = {
        NB_ADMIN_URL = "https://netbird.nukdokplex.ru";
        NB_MANAGEMENT_URL = "https://netbird.nukdokplex.ru";
        NB_ENABLE_ROSENPASS = "true";
        NB_ROSENPASS_PERMISSIVE = "true";
      };
    };
  };

  networking.nftables.firewall.zones.trusted.interfaces = [
    "nb-nukdokplex"
  ];
}
