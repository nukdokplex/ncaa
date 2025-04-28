{ lib, ... }:
{
  options.home.isDesktop = lib.mkEnableOption "desktop config for this home";
}
