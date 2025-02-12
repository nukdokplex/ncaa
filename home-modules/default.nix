{ lib, ezModules, inputs, ... }: {
  imports = lib.attrValues (lib.filterAttrs (name: _: name != "default") ezModules) ++ [
    inputs.spicetify.homeManagerModules.spicetify
  ];
}
