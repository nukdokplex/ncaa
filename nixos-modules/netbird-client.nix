{
  services.netbird = {
    enable = true;

    clients.nukdokplex = {
      # ui.enable is enabled only on hosts with graphics session installed by default
      hardened = false;
      openFirewall = true;
      port = 51820;

      config = {
        ManagementURL = "https://netbird.nukdokplex.ru";
        AdminURL = "https://netbird.nukdokplex.ru";
        RosenpassEnabled = true;
      };
    };
  };

  networking.nftables.firewall.zones.trusted.interfaces = [
    "nb-nukdokplex"
  ];
}
