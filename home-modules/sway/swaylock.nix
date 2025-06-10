{ lib, config, ... }:
{
  programs.swaylock = {
    enable = true;
    settings = {
      show-keyboard-layout = true;
      show-failed-attempts = true;
    };
  };
}
