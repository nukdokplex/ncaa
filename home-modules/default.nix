{ lib, ezModules, inputs, ... }: {
  imports = lib.attrValues (lib.filterAttrs (name: _: name != "default") ezModules) ++ [
    inputs.spicetify.homeManagerModules.spicetify
    inputs.agenix.homeManagerModules.age
    inputs.nixvim.homeManagerModules.nixvim
    inputs.hyprland.homeManagerModules.default
  ];
}
