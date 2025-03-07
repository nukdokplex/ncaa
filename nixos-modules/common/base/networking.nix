{ lib, config, ... }: {
  config = lib.mkIf config.common.base.enable {
    networking.firewall = {
      enable = true;
      allowPing = true;
    };
  };
}
