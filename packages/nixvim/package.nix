{
  pkgs,
  ...
}:
pkgs.nixvim.makeNixvimWithModule {
  inherit pkgs;

  extraSpecialArgs = { inherit (pkgs) lib-custom; };

  module.imports = [ ./modules ];
}
