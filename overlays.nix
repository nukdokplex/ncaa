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
      waybar = prev.waybar.overrideAttrs {
        patches = lib.singleton (
          prev.fetchpatch {
            url = "https://github.com/Alexays/Waybar/compare/0.13.0...0776e694df56c2c849b682369148210d81324e93.patch";
            hash = "sha256-V5CNu4X/Nyay0DJvPbFqa0mLJyU/1B5LzZab+p/xVHA=";
          }
        );
      };
      qutebrowser = prev.qutebrowser.overrideAttrs {
        version = "3.6.1-unstable-2025-07-14";
        src = prev.fetchFromGitHub {
          owner = "coderkun";
          repo = "qutebrowser";
          rev = "79695292c1fc7c8953684ee4cc2105d92ad62d76";
          hash = "sha256-azCsgRz8sKm6wELnf0XK7ui42JwQ3r4jtxZZyH67D1s=";
        };
      };
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
