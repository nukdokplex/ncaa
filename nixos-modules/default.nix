{ ezModules, lib, ... }: {
  # import all modules in this module so this ("default") module become super-module that inherits all nixos modules in this flake
  imports = lib.attrValues (lib.filterAttrs (module: _: module != "default") ezModules);
}
