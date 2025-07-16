{
  pkgs,
  lib,
  ...
}:
{
  programs.steam = lib.mkDefault {
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [
      libgudev
      libvdpau
      libsoup_2_4
      libusb1
      speex
      SDL2
      openal
      libglvnd
      gtk3
      mono
      dbus
    ];

    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  programs.gamemode.enable = lib.mkDefault true;
  programs.gamescope.enable = lib.mkDefault true;
  services.ananicy = lib.mkDefault {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-cpp;
    extraRules = [
      {
        "name" = "gamescope";
        "nice" = -20;
      }
    ];
  };
}
