{
  inputs,
  flakeRoot,
  lib,
  ...
}:
let
  packages = inputs.self.lib.umport {
    path = ./.;
    exclude = [ ./default.nix ];
    recursive = false;
  };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages = inputs.flake-utils.lib.flattenTree (
        pkgs.recurseIntoAttrs (
          lib.mergeAttrsList (
            builtins.map (package: pkgs.callPackage package { inherit inputs flakeRoot; }) packages
          )
        )
      );
    };
}
