{ lib, ... }:
{
  system.autoUpgrade = lib.mkDefault {
    enable = true;

    flake = "github:nukdokplex/ncaa/master";

    operation = "switch";

    dates = "02:00";
    randomizedDelaySec = "60min";
    persistent = true;

    allowReboot = true;
    rebootWindow.lower = "02:00";
    rebootWindow.upper = "06:00";
  };
}
