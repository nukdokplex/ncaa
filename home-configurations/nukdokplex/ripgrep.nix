{ config, lib, ... }:
{
  programs = {
    ripgrep.enable = true;
    ripgrep-all.enable = lib.mkIf config.home.isDesktop true;
  };
}
