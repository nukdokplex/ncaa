{ lib, pkgs, ... }:
{
  "pulseaudio#source" = {
    format = "{format_source}";
    format-source = "mic:{volume:03d}";
    format-source-muted = "mic:mut";

    max-volume = 150;

    on-click = lib.getExe pkgs.pavucontrol;
    on-click-middle = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    on-scroll-up = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 1%+";
    on-scroll-down = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 1%-";

    tooltip = true;
    tooltip-format = "{volume}% {desc}";
  };
}
