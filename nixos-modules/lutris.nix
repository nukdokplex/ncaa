{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.lutris.override {
      steamSupport = true;
      extraPkgs =
        pkgs: with pkgs; [
          wineWowPackages.stableFull
          winetricks
          libgudev
          libvdpau
          libusb1
          speex
        ];
    })
  ];
}
