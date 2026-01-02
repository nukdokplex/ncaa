{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ffmpeg
    yt-dlp
    handbrake
  ];
}
