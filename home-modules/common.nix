{ pkgs, lib, ... }:
{

  stylix.iconTheme = {
    enable = true;
    package = pkgs.papirus-icon-theme.override { color = "adwaita"; };
    light = "Papirus";
    dark = "Papirus-Dark";
  };

  # this config causes adding unwanted nixpkgs overlay
  stylix.targets.gnome-text-editor.enable = false;
}
