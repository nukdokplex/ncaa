{
  lib,
  inputs,
  osConfig,
  ...
}:
{
  imports =
    (with inputs; [
      spicetify.homeManagerModules.spicetify
      agenix.homeManagerModules.age
      hyprland.homeManagerModules.default
      nix-index-database.homeModules.nix-index
      nixcord.homeModules.nixcord
      nixvim.homeModules.nixvim
    ])
    ++
      # this is workaround to make stylix always been imported and prevent config conflicts
      (lib.optional (!osConfig.stylix.enable) inputs.stylix.homeModules.stylix)
    ++ [
      ./file-roller.nix
      ./gaming.nix
      ./is-desktop.nix
      ./nemo.nix
      ./wm-settings.nix
    ];
}
