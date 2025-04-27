{ pkgs, lib, config, ... }:
let
  cfg = config.programs.via;
in
{
  # this module implements programs.via 
  options.programs.via = {
    enable = lib.mkEnableOption "VIA, powerful FOSS configurator for QMK-powered keyboards";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.via ];
    services.udev.packages = [ pkgs.via ];
  };
}
