{ inputs, ... }:
{
  imports = [
    inputs.spicetify.homeManagerModules.spicetify
    inputs.agenix.homeManagerModules.age
    inputs.hyprland.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    inputs.nixcord.homeModules.nixcord
    inputs.stylix.homeModules.stylix
  ]
  ++ [
    ./file-roller.nix
    ./gaming.nix
    ./is-desktop.nix
    ./nemo.nix
    ./nm-applet.nix
    ./wm-settings.nix
    ./swayidle2.nix
  ];
}
