{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.nemo;
in
{
  options.programs.nemo = {
    enable = lib.mkEnableOption "Nemo, the file manager from Cinnamon";
    package = lib.mkPackageOption pkgs "nemo" { };
    extensions = lib.mkOption {
      default = [ ];
      defaultText = "[ ]";
      example = lib.literalExpression "[ pkgs.nemo-seahorse ]";
      description = "Specifies which extensions should be installed to Nemo file manager.";
      type = lib.types.listOf lib.types.package;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.singleton (
      pkgs.nemo-with-extensions.override {
        nemo = cfg.package;
        extensions = cfg.extensions;
        useDefaultExtensions = true;
      }
    );
  };
}
