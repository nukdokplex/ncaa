{ lib, config, ... }: {
  services.yggdrasil = {
    settings.MulticastInterfaces = [{
      Regex = "enp42s0";
      Beacon = true;
      Listen = true;
    }];
    configFile = config.age.secrets.yggdrasil.path;
  };

  age.secrets.yggdrasil.rekeyFile = ./yggdrasil.age;
}
