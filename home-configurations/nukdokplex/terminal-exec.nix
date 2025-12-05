{ lib, ... }:
{
  xdg.terminal-exec = {
    enable = lib.mkDefault true;
    settings = {
      default = [ "foot.desktop" ];
      GNOME = [ "foot.desktop" ];
    };
  };
}
