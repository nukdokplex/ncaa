{ lib, pkgs, ... }:
{
  "pulseaudio#sink" = {
    format = "vol\n{volume:03d}";
    format-bluetooth = "bth\n{volume:03d}";
    format-muted = "vol\nmut";

    max-volume = 150;

    on-click = lib.getExe pkgs.pavucontrol;
    on-click-middle = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
    on-scroll-up = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%+";
    on-scroll-down = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%-";

    tooltip = true;
    tooltip-format = "{volume}% {desc}";
  };
}
