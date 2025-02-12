{ lib, ezModules, ... }: {
  imports = lib.attrValues (lib.filterAttrs (name: _: name != "default") ezModules);
}
