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

    light-packages = _: prev: {
      yazi = prev.yazi.override {
        ffmpeg = null; # ffmpeg is huge
      };
      fastfetch = prev.fastfetch.override {
        audioSupport = false;
        brightnessSupport = false;
        dbusSupport = false;
        flashfetchSupport = false;
        gnomeSupport = false;
        imageSupport = false;
        openclSupport = false;
        openglSupport = false;
        rpmSupport = false;
        sqliteSupport = false;
        terminalSupport = false;
        vulkanSupport = false;
        waylandSupport = false;
        x11Support = false;
        xfceSupport = false;
      };
    };

    overrides = _: prev: {
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
