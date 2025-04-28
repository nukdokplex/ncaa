{
  config,
  flakeRoot,
  lib,
  ...
}:
{
  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."10-uplink" = { };

  # systemd drop-in to keep address secret
  age.secrets.uplink-address = {
    path = "/run/systemd/network/10-uplink.network.d/address.conf";
    rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/uplink-address.age;
    owner = "systemd-network";
    group = "systemd-network";
  };
}
