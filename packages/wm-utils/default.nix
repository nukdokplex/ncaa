# inpired by voronind's implementation of swayscript https://git.voronind.com/voronind/nix/src/commit/86f88b677e79b2a92e197f6c4e4a4c935e3ccdc6/package/swayscript/default.nix#L1
{
  inputs,
  flakeRoot,
  pkgs,
  ...
}:
let
  raw = pkgs.writeText "wm-utils" (
    inputs.self.lib.file-utils.readFiles (inputs.self.lib.file-utils.ls ./scripts)
  );
  script =
    (pkgs.replaceVars raw {
      inherit (pkgs)
        jq
        grim
        slurp
        swappy
        ;
      sounds = "${flakeRoot}/static/sounds";
    }).overrideAttrs
      (old: {
        doCheck = false;
      });
in
{
  wm-utils = pkgs.writeShellScriptBin "wm-utils" (builtins.readFile script + "\n\${@}");
}
