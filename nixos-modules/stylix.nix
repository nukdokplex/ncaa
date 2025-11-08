{ lib, pkgs, ... }:
{
  stylix = lib.mkDefault {
    enable = true;

    opacity = {
      applications = 0.7;
      desktop = 0.7;
      popups = 0.7;
      terminal = 0.7;
    };

    homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
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
