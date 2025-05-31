{
  inputs,
  pkgs,
  ...
}:
{
  nixvim = pkgs.makeNixvimWithModule {
    inherit pkgs;

    extraSpecialArgs = { inherit inputs; };

    module.imports = [ ./modules ];
  };
}
