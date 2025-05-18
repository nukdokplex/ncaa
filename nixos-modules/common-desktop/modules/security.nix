{ pkgs, lib, ... }:
{
  security.polkit.enable = true;

  services.pcscd = {
    enable = true;
    plugins = with pkgs; [
      ccid
    ];
  };

  home-manager.sharedModules = lib.singleton {
    programs.gpg.scdaemonSettings = {
      disable-ccid = true;
    };
  };
}
