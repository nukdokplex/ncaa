{
  lib,
  inputs,
  flakeRoot,
  ...
}:
{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    let
      flattenPkgs =
        separator: path: value:
        if lib.isDerivation value then
          {
            ${lib.concatStringsSep separator path} = value;
          }
        else if lib.isAttrs value then
          lib.concatMapAttrs (name: flattenPkgs separator (path ++ [ name ])) value
        else
          # Ignore the functions which makeScope returns
          { };
    in
    {
      legacyPackages = lib.filesystem.packagesFromDirectoryRecursive (
        let
          inputsScope = lib.makeScope pkgs.newScope (_: {
            inherit inputs;
          });
        in
        {
          directory = flakeRoot + /packages;
          inherit (inputsScope)
            newScope
            callPackage
            ;
        }
      );
      packages = flattenPkgs "/" [ ] config.legacyPackages;
    };
}
