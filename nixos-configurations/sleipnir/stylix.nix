{ pkgs, ... }:
{
  stylix = {
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/v9/wallhaven-v9pxpm.jpg";
      sha256 = "0x4s8pfr7rcpd6zhl2pfn7q4743z18a3il29cc9jilfh0rndxzjz";
    };

    # opacity = {
    #   applications = 0.90;
    #   desktop = 0.90;
    #   popups = 0.90;
    #   terminal = 0.90;
    # };

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
