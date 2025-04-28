{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.tlp = {
    enable = true;
    settings = {
      RUNTIME_PM_ON_BAT = "on";
    };
  };
  services.power-profiles-daemon.enable = lib.mkForce false;
}
