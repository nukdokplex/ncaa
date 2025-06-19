{
  pkgs,
  config,
  lib,
  ...
}:
{
  hardware.keyboard.qmk.enable = true;

  environment.systemPackages = with pkgs; [
    qmk
  ];
}
