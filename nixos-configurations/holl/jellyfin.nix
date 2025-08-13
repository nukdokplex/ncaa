{ pkgs, ... }:
{

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "nukdokplex";
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
}
