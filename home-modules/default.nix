{
  lib,
  inputs,
  osConfig,
  ...
}:
{
  imports = [
    inputs.spicetify.homeManagerModules.spicetify
    inputs.agenix.homeManagerModules.age
    inputs.hyprland.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
    inputs.nixcord.homeModules.nixcord
  ]
  ++
    # this is workaround to make stylix always been imported and prevent config conflicts
    (lib.optional (!osConfig.stylix.enable) inputs.stylix.homeManagerModules.stylix)
  ++ [
    ./file-roller.nix
    ./gaming.nix
    ./is-desktop.nix
    ./nemo.nix
    ./nm-applet.nix
    ./wm-settings.nix
    ./xdg-terminal-exec.nix
    ./swayidle2.nix
  ];
}
