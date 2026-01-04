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
      # fix yyggdrasil missing meta.mainProgram
      yggdrasil = prev.yggdrasil.overrideAttrs (
        _: prevAttrs: {
          meta = prevAttrs.meta // {
            mainProgram = "yggdrasil";
          };
        }
      );
      qbittorrent-nox = prev.qbittorrent-nox.overrideAttrs (finalAttrs: {
        version = "5.1.4";
        src = prev.fetchFromGitHub {
          owner = "qbittorrent";
          repo = "qBittorrent";
          rev = "release-${finalAttrs.version}";
          hash = "sha256-9RfKir/e+8Kvln20F+paXqtWzC3KVef2kNGyk1YpSv4=";
        };
      });
      statix = prev.statix.overrideAttrs (_o: rec {
        src = prev.fetchFromGitHub {
          owner = "oppiliappan";
          repo = "statix";
          rev = "43681f0da4bf1cc6ecd487ef0a5c6ad72e3397c7";
          hash = "sha256-LXvbkO/H+xscQsyHIo/QbNPw2EKqheuNjphdLfIZUv4=";
        };

        cargoDeps = prev.rustPlatform.importCargoLock {
          lockFile = src + "/Cargo.lock";
          allowBuiltinFetchGit = true;
        };
      });
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
