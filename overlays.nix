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
        { system, config, ... }:
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

    lib-custom = final: prev: {
      lib-custom = config.flake.lib';
    };

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
