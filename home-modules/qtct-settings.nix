{
  lib,
  pkgs,
  config,
  ...
}:
let
  iniFormat = pkgs.formats.ini {
    listToValue = values: lib.concatStringsSep ", " values;
  };
  cfg = config.qt;
in
{
  options.qt.qtctSettings = lib.mkOption {
    description = "qtct configuration.";
    inherit (iniFormat) type;
    default = { };
  };

  config.xdg.configFile = lib.mkIf (cfg.qtctSettings != { }) (
    let
      conf = iniFormat.generate "qtct-config" cfg.qtctSettings;
    in
    {
      "qt5ct/qt5ct.conf".source = conf;
      "qt6ct/qt6ct.conf".source = conf;
    }
  );
}
