{ ezModules, lib, ... }:
{
  imports = with ezModules; [
    base-system
    fonts
    graphics
    greetd
    media-mounting
    networkmanager
    pipewire
    printing
    smartcard
    stylix
    usb-utils
  ];

  security.polkit.enable = true;

  home-manager.sharedModules = lib.singleton {
    home.isDesktop = true;
  };
}
