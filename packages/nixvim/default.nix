{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nixvim = inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
    inherit pkgs;

    extraSpecialArgs = { inherit inputs; };

    module.imports = [ ./modules ];
  };
}
