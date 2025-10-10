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
      clblast = prev.clblast.overrideAttrs (
        _: _: {
          patches = [
            (prev.fetchpatch {
              name = "clblast-fix-cmake4.patch";
              url = "https://github.com/CNugteren/CLBlast/commit/dd714f1b72aa8c341e5a27aa9e968b4ecdaf1abb.patch";
              includes = [ "CMakeLists.txt" ];
              hash = "sha256-AVFzEdj1CaVSJxOcn5PoqFb+b8k5YgSMD3VhvHeBd7o=";
            })
          ];
        }
      );
      intel-graphics-compiler = prev.intel-graphics-compiler.overrideAttrs (
        _: _: {
          patches = [
            (prev.fetchpatch {
              name = "bump-cmake.patch";
              url = "https://github.com/SuperSandro2000/nixpkgs/raw/ac194b0e0dd1ad78620bb77c31c6ca54b6ef8caf/pkgs/by-name/in/intel-graphics-compiler/bump-cmake.patch";
              hash = "sha256-w74ET7SVQrIuTuZ0c/eBoEP0EdG7Y0FEAJUxv7KVLvI=";
            })
          ];
        }
      );
      libvdpau-va-gl = prev.libvdpau-va-gl.overrideAttrs (
        _: _: {
          patches = [
            # cmake-4 compatibility
            # track if https://github.com/NixOS/nixpkgs/pull/449482
            (prev.fetchpatch {
              name = "cmake-4-1.patch";
              url = "https://github.com/i-rinat/libvdpau-va-gl/commit/30c8ac91f3aa2843f7dc1c1d167e09fad447fd91.patch?full_index=1";
              hash = "sha256-PFEqBg3NE0fVFBAW4zdDbh8eBfKyPX3BZ8P2M15Qq5A=";
            })
            (prev.fetchpatch {
              name = "cmake-4-2.patch";
              url = "https://github.com/i-rinat/libvdpau-va-gl/commit/38c7d8fddb092824cbcdf2b11af519775930cc8b.patch?full_index=1";
              hash = "sha256-XsX/GLIS2Ce7obQJ4uVhLDtTI1TrDAGi3ECxEH6oOFI=";
            })
            (prev.fetchpatch {
              name = "cmake-4-3.patch";
              url = "https://github.com/i-rinat/libvdpau-va-gl/commit/a845e8720d900e4bcc89e7ee16106ce63b44af0.patch?full_index=1";
              hash = "sha256-lhiZFDR2ytDmo9hQUT35IJS4KL4+nYWAOnxZlj7u3tM=";
            })
          ];
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
