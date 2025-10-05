{ lib, config, ... }:
let

  mkTarget =
    let
      globalConfig = config;
    in
    {
      name,
      humanName ? null,
      config ? { },
      options ? { },
      ...
    }:
    {
      options.wm-quirks.targets.${name} = lib.recursiveUpdate {
        enable = lib.mkOption {
          default = globalConfig.wm-quirks.enableAllTargets;
          example = !globalConfig.wm-quirks.enableAllTargets;
          description = "Whether to enable ${if humanName == null then name else humanName} WM quirks.";
          type = lib.types.bool;
        };
      } options;

      config = lib.mkIf globalConfig.wm-quirks.targets.${name}.enable config;
    };
in
{
  options.wm-quirks = {
    enableAllTargets = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable all targets for WM quirks";
      type = lib.types.bool;
    };
  };

  imports =
    builtins.readDir ./.
    |> (contents: lib.removeAttrs contents [ "default.nix" ])
    |> lib.filterAttrs (name: value: (value == "regular") -> (lib.hasSuffix ".nix" name))
    |> lib.filterAttrs (
      name: value:
      (value == "directory")
      -> (builtins.pathExists ./${name}/default.nix && builtins.readFileType ./${name}/default.nix)
    )
    |> lib.mapAttrsToList (name: _: import ./${name} mkTarget);
}
