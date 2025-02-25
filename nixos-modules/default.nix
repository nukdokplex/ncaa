{ ezModules, lib, inputs, flakeRoot, ... }: {
  # import all modules in this module so this ("default") module become super-module that inherits all nixos modules in this flake
  imports = lib.attrValues (lib.filterAttrs (module: _: module != "default") ezModules) ++ [
    inputs.stylix.nixosModules.stylix
    inputs.nur.modules.nixos.default
    inputs.agenix.nixosModules.age
    inputs.hyprland.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.tssp.nixosModules.default
  ];

  nixpkgs.config = import /${flakeRoot}/nixpkgs-config.nix;
}
