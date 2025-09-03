{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  nixpkgs.localSystem.system = "x86_64-linux";

  imports = [
    (inputs.nixos-hardware + /common/cpu/intel/alder-lake)
    (inputs.nixos-hardware + /common/gpu/intel/alder-lake)
    (inputs.nixos-hardware + /common/pc)
    (inputs.nixos-hardware + /common/pc/ssd)
  ];

  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      intel-ocl
    ];
  };

  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  nixpkgs.overlays = [
    (_: prev: {
      jellyfin-ffmpeg = prev.jellyfin-ffmpeg.override {
        # Exact version of ffmpeg_* depends on what jellyfin-ffmpeg package is using.
        # In 24.11 it's ffmpeg_7-full.
        # See jellyfin-ffmpeg package source for details
        ffmpeg_7-full = prev.ffmpeg_7-full.override {
          withMfx = false; # This corresponds to the older media driver
          withVpl = true; # This is the new driver
          withUnfree = true;
        };
      };
    })
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;
}
