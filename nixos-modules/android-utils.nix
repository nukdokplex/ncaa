{ pkgs, ... }:
{
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    scrcpy # remote desktop through adb
  ];
}
