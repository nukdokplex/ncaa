{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/5d/wallhaven-5dl1g7.jpg";
      hash = "sha256-w9x5FzjFGZy75fYwuKHM0pi+Sda2bP4KY8fWpP/nVFY=";
    };
    polarity = "dark";
    base16Scheme = {
      system = "base16";
      name = "Apathy modified";
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
        base0D = "#4C963E";
        base0E = "#96883E";
        base0F = "#3E965B";
      };
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.nerd-fonts.dejavu-sans-mono;
        name = "DejaVuSansM Nerd Font Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    cursor =
      let
        themeVariant = "Dracula";
        colorVariant = "Green";
        package = pkgs.afterglow-cursors-recolored.override {
          themeVariants = [ themeVariant ];
          draculaColorVariants = [ colorVariant ];
        };
      in
      {
        inherit package;
        name = "Afterglow-Recolored-${themeVariant}-${colorVariant}";
        size = 32;
      };
  };
}
