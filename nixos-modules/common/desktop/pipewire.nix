{ lib, config, ... }: {
  config = lib.mkIf config.common.desktop.enable {
    services.pipewire = {
      enable = true;
      jack.enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
      };
    };
  };
}

