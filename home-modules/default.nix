{
  lib,
  inputs,
  ...
}:
{
  imports =
    [
      inputs.spicetify.homeManagerModules.spicetify
      inputs.agenix.homeManagerModules.age
      inputs.hyprland.homeManagerModules.default
      inputs.nix-index-database.hmModules.nix-index
      inputs.nixcord.homeModules.nixcord
    ]
    ++ [
      ./file-roller.nix
      ./gaming.nix
      ./is-desktop.nix
      ./nemo.nix
      ./nm-applet.nix
      ./wm-settings.nix
    ];
}
