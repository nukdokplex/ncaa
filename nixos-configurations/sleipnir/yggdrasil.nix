{
  services.yggdrasil = {
    settings.MulticastInterfaces = [
      {
        Regex = "uplink.*";
        Beacon = true;
        Listen = true;
      }
    ];
  };
}
