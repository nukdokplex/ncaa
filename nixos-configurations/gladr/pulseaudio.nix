{ lib, ... }:
{
  services.pipewire.enable = lib.mkForce false;

  services.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  nixpkgs.config.pulseaudio = true;

  services.jack = {
    alsa = {
      enable = true;
      support32Bit = true;
    };
    loopback = {
      enable = true;
    };
  };
}
