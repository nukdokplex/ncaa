{ pkgs, lib, ... }:
let
  video = pkgs.fetchurl {
    urls = [
      "https://videos.pexels.com/video-files/7385122/7385122-uhd_3840_2160_30fps.mp4"
      "https://web.archive.org/web/https://videos.pexels.com/video-files/7385122/7385122-uhd_3840_2160_30fps.mp4"
    ];
    sha256 = "17g3l6450f21ns3xq6xg20rvfa3g2gcccw5cd8g380rffnjm2fdm";
  };
in
{
  stylix = {
    video = pkgs.runCommandNoCC "stylix-video-wallpaper" { } ''
      '${lib.getExe pkgs.ffmpeg}' \
        -i '${video}' \
        -vf "scale=2560:-2" \
        -c:v libx264 \
        -preset veryfast \
        -tune film \
        -an \
        -f mp4 \
        $out
    '';

    opacity = {
      applications = 0.90;
      desktop = 0.90;
      popups = 0.90;
      terminal = 0.90;
    };

    polarity = "dark";

    base16Scheme = {
      system = "base16";
      slug = "apathy";
      name = "Apathy";
      author = "Jannik Siebert (https://github.com/janniks)";
      variant = "dark";
      palette = {
        base00 = "#031A16";
        base01 = "#0B342D";
        base02 = "#184E45";
        base03 = "#2B685E";
        base04 = "#5F9C92";
        base05 = "#81B5AC";
        base06 = "#A7CEC8";
        base07 = "#D2E7E4";
        base08 = "#3E9688";
        base09 = "#3E7996";
        base0A = "#3E4C96";
        base0B = "#883E96";
        base0C = "#963E4C";
        base0D = "#96883E";
        base0E = "#4C963E";
        base0F = "#3E965B";
      };
    };
  };
}
