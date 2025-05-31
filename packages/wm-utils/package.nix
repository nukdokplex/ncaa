# inpired by voronind's implementation of swayscript https://git.voronind.com/voronind/nix/src/commit/86f88b677e79b2a92e197f6c4e4a4c935e3ccdc6/package/swayscript/default.nix#L1
{
  lib,
  writeShellApplication,

  kdePackages,
  jq,
  grim,
  slurp,
  fuzzel,
  swappy,
}:
let
  scriptsDir = ./scripts;

  isScript = name: value: value == "regular" && lib.hasSuffix ".sh" name;

  files = builtins.mapAttrs (name: value: { inherit name value; }) (builtins.readDir scriptsDir);
  scriptNames = builtins.map (elem: elem.name) (
    builtins.filter (elem: isScript elem.name elem.value) files
  );
  scriptPaths = builtins.map (name: /${scriptsDir}/${name}) scriptNames;

  rawCombinedScript =
    builtins.concatStringsSep "\n\n" (builtins.map (path: builtins.readFile path) scriptPaths)
    + "\n\${@}"; # ${@} to call function by script arg

in
writeShellApplication (
  lib.fix (final: {
    name = "wm-utils";

    text = rawCombinedScript;

    runtimeInputs = [
      # parsers
      jq

      # screenshot stuff
      grim
      slurp
      swappy

      # TODO: make separated fuzzel helper package
      fuzzel
    ];

    runtimeEnv = {
      SOUNDS = "${kdePackages.oxygen-sounds}/share/sounds/oxygen/stereo";
      SOUNDS_EXTENSION = ".ogg";
    };

    meta = {
      homepage = "https://github.com/nukdokplex/ncaa";
      description = "Window manager (Hyprland and Sway) helper utilities.";
      shortDescription = final.meta.description;
      license = [ lib.licenses.gpl3-only ];
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      maintainers = [ lib.maintainers.nukdokplex ];
      platforms = [ lib.platforms.all ];
    };
  })
)
