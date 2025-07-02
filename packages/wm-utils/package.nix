# inpired by voronind's implementation of swayscript https://git.voronind.com/voronind/nix/src/commit/86f88b677e79b2a92e197f6c4e4a4c935e3ccdc6/package/swayscript/default.nix#L1
{
  lib,
  writeShellApplication,

  fuzzel,
  grim,
  jq,
  kdePackages,
  slurp,
  swappy,
  wl-clipboard,
  wireplumber,
  tesseract,
  tts-custom,
  ...
}:
let
  scriptsDir = ./scripts;

  isScript = name: value: value == "regular" && lib.hasSuffix ".sh" name;

  files = lib.attrsToList (builtins.readDir scriptsDir);
  scriptNames = builtins.map (elem: elem.name) (
    builtins.filter (elem: isScript elem.name elem.value) files
  );
  scriptPaths = builtins.map (name: /${scriptsDir}/${name}) scriptNames;

  rawCombinedScript =
    builtins.concatStringsSep "\n\n" (builtins.map (path: builtins.readFile path) scriptPaths)
    + "\n\n\"\${@}\""; # ${@} to call function by script arg

in
writeShellApplication {
  name = "wm-utils";

  text =
    ''
      SOUNDS='${kdePackages.oxygen-sounds}/share/sounds/oxygen/stereo'
    ''
    + rawCombinedScript;

  runtimeEnv = {
    TESSDATA_PREFIX = "${tesseract}/share/tessdata";
  };

  runtimeInputs = [
    fuzzel
    grim
    jq
    slurp
    swappy
    wireplumber
    tesseract
    tts-custom
  ];

  meta = {
    homepage = "https://github.com/nukdokplex/ncaa";
    description = "Window manager (Hyprland and Sway) helper utilities.";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nukdokplex ];
    platforms = lib.platforms.all;
  };
}
