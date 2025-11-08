{ lib, ... }:
{
  services.pcscd.enable = true;

  hardware.gpgSmartcards.enable = true;

  home-manager.sharedModules = lib.singleton {
    programs.gpg.scdaemonSettings = {
      disable-ccid = true;
    };
  };
}
