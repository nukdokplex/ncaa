{ lib, config, ... }: {
  config = lib.mkIf config.common.base.enable {
    networking.networkmanager = {
      enable = true;
    };
  };
}
