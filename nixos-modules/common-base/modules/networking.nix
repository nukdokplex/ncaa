{ lib, config, ... }: {
  networking.firewall = {
    enable = true;
    allowPing = true;
  };
}
