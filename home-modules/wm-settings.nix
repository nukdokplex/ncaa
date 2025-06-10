{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.wm-settings = {
    deviceUsesBattery = lib.mkEnableOption "battery related components";
    beEnergyEfficient = lib.mkEnableOption "energy-effective configration";

    defaultApplications =
      builtins.mapAttrs
        (
          name: value:
          let
            niceName = lib.concatStringsSep " " (builtins.split "([[:upper:]]+)" name);
          in
          lib.mkPackageOption pkgs niceName value
        )
        {
          webBrowser.default = "firefox";
          fileManager.default = [
            "xfce"
            "thunar"
          ];
          mailClient.default = "thunderbird";
          passwordManager.default = "keepassxc";
          terminal.default = "foot";
        };

    idleTimeouts =
      builtins.mapAttrs
        (
          name: value:
          let
            niceName = lib.toLower (lib.concatStringsSep " " (builtins.split "([[:upper:]]+)" name));
          in
          lib.mkOption value
          // {
            description = "Time to trigger ${niceName} timeout (in seconds)";
            example = lib.literalExpression "-1";
            type = lib.types.int;
          }
        )
        {
          dimBacklight.default = 60;
          offBacklight.default = 300;
          sessionLock.default = 310;
          systemSuspend.default = 1800;
        };

    workspaceBoundStartup = lib.mkOption {
      description = "Workspace-bound startups";
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            workspaceNumber = lib.mkOption {
              type = lib.types.ints.unsigned;
              description = "workspace number in which window should be spawned";
            };
            command = lib.mkOption {
              type = lib.types.str;
              description = "command to execute";
            };
          };
        }
      );
    };
  };
}
