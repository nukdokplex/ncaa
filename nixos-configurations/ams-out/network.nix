{ lib, config, ... }: {
  networking = {
    nftables = {
      enable = true;
    };
  };
  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.driver = "virtio_net";
    };
  };
}
