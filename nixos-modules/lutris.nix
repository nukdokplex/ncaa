{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.lutris.override {
      steamSupport = false;
      extraPkgs =
        pkgs: with pkgs; [
          wineWowPackages.stableFull
          libgudev
          libvdpau
          libsoup_2_4
          libusb1
          speex
        ];
    })
  ];
}
