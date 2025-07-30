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
          libusb1
          speex
        ];
    })
  ];
}
