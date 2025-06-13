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

    overrides = final: prev: {
      wl-clipboard = prev.wl-clipboard.overrideAttrs (
        finalAttrs: prevAttrs: {
          version = "2.2-unstable-2024-04-24";

          src = prev.fetchFromGitHub {
            owner = "bugaevc";
            repo = "wl-clipboard";
            rev = "aaa927ee7f7d91bcc25a3b68f60d01005d3b0f7f";
            hash = "sha256-V8JAai4gZ1nzia4kmQVeBwidQ+Sx5A5on3SJGSevrUU=";
          };
        }
      );
    };

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
