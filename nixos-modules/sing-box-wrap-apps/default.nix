{ lib, ... }:
let
  # deadnix: skip
  selectiveProxyPort = 9900;
  # deadnix: skip
  allProxyPort = 9901;
in
{
  nixpkgs.overlays =
    [
      (_: prev: {
        vesktop = prev.vesktop.overrideAttrs (
          _: prevAttrs: {
            postFixup = prevAttrs.postFixup + ''
              mv "$out/bin/vesktop" "$out/bin/.vesktop-unproxified"
              cat > $out/bin/vesktop << EOF
              #!${prev.runtimeShell}
              ${lib.getExe prev.proxychains-ng} $out/bin/.vesktop-unproxified "\$@"
              EOF
              chmod +x $out/bin/vesktop
            '';
          }
        );
      })
    ]
    |> lib.mkAfter;
}
