{
  pkgs,
  inputs,
  lib,
  ...
}:
pkgs.nixvim.makeNixvimWithModule {
  inherit pkgs;

  extraSpecialArgs = {
    inherit inputs;
  };

  module.imports = lib.singleton ./modules;
}
