{
  lib,
  pkgs,
  ...
}:
{
  stylix = lib.mkDefault {
    enable = true;

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
