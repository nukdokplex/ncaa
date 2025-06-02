{
  lib,
  inputs,
  withSystem,
  config,
  ...
}:
{
  flake.overlays = {
    # this adds all packages under outputs.packages.${system}
    pkgs =
      final: prev:
      withSystem prev.stdenv.hostPlatform.system (
        { system, ... }:
        let
          packageNameValuePairs = lib.attrsToList config.packages;
          packagePathPkgPairs = builtins.map (elem: {
            path = lib.splitString "/" elem.name;
            pkg = elem.value;
          }) packageNameValuePairs;
        in
        builtins.foldl' (
          acc: elem: lib.recursiveUpdate acc (lib.setAttrByPath elem.path elem.pkg)
        ) { } packagePathPkgPairs
      );

    # library functions
    # there is a reason why i don't modify lib
    lib-custom = final: prev: { lib-custom = inputs.self.outputs.lib; };

    # imports pkgs and custom-lib
    default = lib.composeManyExtensions (
      with inputs.self.outputs.overlays;
      [
        pkgs
        custom-lib
      ]
    );

    # imports flake inputs' overlays
    imported = lib.composeManyExtensions (
      with inputs;
      [
        nixvim.overlays.default
        agenix-rekey.overlays.default
      ]
    );
  };
}
