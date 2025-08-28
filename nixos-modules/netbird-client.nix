{ lib, config, ... }:
{
  services.netbird = {
    enable = true;

    clients.nukdokplex = {
      # ui.enable is enabled only on hosts with graphics session installed by default
      hardened = true;
      openFirewall = true;
      port = 51820;

      environment = {
        NB_MANAGEMENT_URL = "https://netbird.nukdokplex.ru";
        NB_ADMIN_URL = "https://netbird.nukdokplex.ru";
      };
    };
  };

  users.users.netbird-nukdokplex.extraGroups = lib.mkIf config.services.resolved.enable (
    lib.singleton "systemd-resolve"
  );
}
