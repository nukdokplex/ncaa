{
  lib,
  config,
  pkgs,
  ...
}:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  environment.systemPackages = with pkgs; [
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
  ];
}
