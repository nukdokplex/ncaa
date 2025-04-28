{
  lib,
  config,
  flakeRoot,
  ...
}:
{
  services.yggdrasil = {
    enable = lib.mkDefault true;
    configFile = config.age.secrets.yggdrasil.path;
    openMulticastPort = true;
  };

  age.secrets.yggdrasil.rekeyFile =
    flakeRoot + /secrets/generated/${config.networking.hostName}/yggdrasil.age;
}
