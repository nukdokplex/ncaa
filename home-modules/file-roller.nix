{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.file-roller;
in
{
  options.programs.file-roller = {
    enable = lib.mkEnableOption "File Roller, an archive manager for GNOME";
    package = lib.mkPackageOption pkgs "file-roller" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.singleton cfg.package;
    dbus.packages = lib.singleton cfg.package;
  };
}
