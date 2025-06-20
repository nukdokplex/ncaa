{
  lib,
  ezModules,
  inputs,
  ...
}:
{
  imports =
    [
      inputs.spicetify.homeManagerModules.spicetify
      inputs.agenix.homeManagerModules.age
      inputs.nixvim.homeManagerModules.nixvim
      inputs.hyprland.homeManagerModules.default
      inputs.nix-index-database.hmModules.nix-index
    ]
    ++ (with ezModules; [
      file-roller
      gaming
      is-desktop
      nemo
      nm-applet
      wm-settings
    ]);
}
