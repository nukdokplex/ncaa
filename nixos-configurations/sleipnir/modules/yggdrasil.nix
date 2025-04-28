{
  services.yggdrasil = {
    settings.MulticastInterfaces = [
      {
        Regex = "enp42s0";
        Beacon = true;
        Listen = true;
      }
    ];
  };
}
