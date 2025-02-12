{ lib, config, ... }: {
  config = lib.mkIf config.common.desktop.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
