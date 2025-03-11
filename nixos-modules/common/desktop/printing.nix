{ config, lib, ... }: {
  config = lib.mkIf config.common.desktop.enable {
    services.printing.enable = true;
  };
}
