{ lib, config, ... }:
let
  capableToImport = file: (builtins.elem file.value [ "regular" "symlink" ]) && (lib.hasSuffix ".nix" file.name);
  importDir = dir: (
    builtins.map 
      (file: /${dir}/${file.name})
      (
        builtins.filter
          (file: capableToImport file)
          (
            lib.mapAttrsToList
              (name: value: lib.nameValuePair name value)
              (builtins.readDir dir)
          )
      )
  );
in {
  options.common = {
    base.enable = lib.mkEnableOption "base system configuration";
    desktop.enable = lib.mkEnableOption "base desktop system configuration";
  };

  imports = (importDir ./base) ++ (importDir ./desktop);
}
