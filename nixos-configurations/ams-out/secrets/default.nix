{
  age.secrets = {
    wan_address = {
      file = ./wan_address;
      owner = "systemd-network";
      group = "systemd-network";
      path = "/run/systemd/network/10-wan.network.d/address.conf";
    };
  };
}
