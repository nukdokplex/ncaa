{ lib, config, ... }:
{
  networking.networkmanager = {
    enable = true;
  };
}
