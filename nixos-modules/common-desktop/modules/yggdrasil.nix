{
  lib,
  config,
  ...
}:
{
  services.yggdrasil = {
    enable = lib.mkDefault true;
    configFile = config.age.secrets.yggdrasil.path;
    openMulticastPort = true;
  };

  age.secrets.yggdrasil = { };
}
