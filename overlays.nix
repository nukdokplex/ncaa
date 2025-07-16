{
  lib,
  inputs,
  config,
  ...
}:
{
  flake.overlays = {
    # this adds all packages under outputs.packages.${system}
    packages =
      _: prev:
      let
        system = prev.stdenv.hostPlatform.system;
      in
      if builtins.elem system config.systems then
        let
          packageNameValuePairs = lib.attrsToList inputs.self.outputs.packages.${system};
          packagePathPkgPairs = builtins.map (elem: {
            path = lib.splitString "/" elem.name;
            pkg = elem.value;
          }) packageNameValuePairs;
        in
        builtins.foldl' (
          acc: elem: lib.recursiveUpdate acc (lib.setAttrByPath elem.path elem.pkg)
        ) { } packagePathPkgPairs
      else
        { };

    overrides = _: prev: {
      wl-clipboard = prev.wl-clipboard.overrideAttrs (
        _: _: {
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

    lib-custom = _: _: {
      lib-custom = config.flake.lib';
    };

    imports = lib.composeManyExtensions [
      inputs.nixvim.overlays.default
      inputs.agenix-rekey.overlays.default
    ];
  };
}
