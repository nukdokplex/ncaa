{
  lib,
  pkgs,
  config,
  ...
}:
{
  stylix = lib.mkDefault {
    enable = true;
    image = pkgs.fetchurl {
      urls = [
        "https://w.wallhaven.cc/full/57/wallhaven-57loy5.jpg"
        "https://web.archive.org/web/https://w.wallhaven.cc/full/57/wallhaven-57loy5.jpg"
      ];
      sha256 = "187734kcjslgijlqsc9dc58vbx25ibmnr1q58313q2s9na1z782c";
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

    opacity = {
      applications = 0.7;
      desktop = 0.7;
      popups = 0.7;
      terminal = 0.7;
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
