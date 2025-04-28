{
  lib,
  ezModules,
  inputs,
  ...
}:
let
  excludedModules = [
    "common"
  ];
in
{
  imports =
    lib.attrValues (
      lib.filterAttrs (name: _: !(builtins.elem name (excludedModules ++ [ "default" ]))) ezModules
    )
    ++ [
      inputs.spicetify.homeManagerModules.spicetify
      inputs.agenix.homeManagerModules.age
      inputs.nixvim.homeManagerModules.nixvim
      inputs.hyprland.homeManagerModules.default
      inputs.nix-index-database.hmModules.nix-index
    ];
}
