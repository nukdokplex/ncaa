{ lib, config, ... }: {
  security.rtkit.enable = lib.mkDefault true; # pipewire uses this to acquire realtime priority
  services.pipewire = {
    enable = true;
    jack.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
    };
  };
}

