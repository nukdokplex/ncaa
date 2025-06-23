{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.home.isDesktop {
    programs.nemo = lib.mkDefault {
      enable = true;
      extensions = with pkgs; [
        nemo-preview
        nemo-emblems
        nemo-seahorse
        nemo-fileroller
      ];
    };

    programs.file-roller.enable = lib.mkDefault true;

    dbus.packages = with pkgs; [
      libcryptui # needed for nemo-seahorse
    ];
  };
}
