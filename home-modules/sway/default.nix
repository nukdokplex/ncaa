{
  pkgs,
  lib,
  lib',
  config,
  ...
}@args:
{
  wayland.windowManager.sway = lib.fix (final: {
    enable = lib.mkDefault (
      lib.attrByPath [
        "osConfig"
        "programs"
        "sway"
        "enable"
      ] false args
    );
    checkConfig = false;
    package = lib.attrByPath [
      "osConfig"
      "programs"
      "sway"
      "package"
    ] pkgs.sway args;
    wrapperFeatures.gtk.enable = true;
    config = {
      startup = lib.mkBefore (
        [
          { command = "'${lib.getExe pkgs.soteria}'"; }
        ]
        ++ (lib.optional (config.stylix.video != null) {
          command = "'${lib.getExe config.programs.mpvpaper.package}' -o \"no-audio --hwdec=auto --loop-file --panscan=1\" '*' '${config.stylix.video}'";
        })
      );
      bars = [ ]; # remove standard bar

      gaps.inner = 10;
      gaps.outer = 10;
      window.border = 3;
      floating.border = final.config.window.border;

      defaultWorkspace = "workspace number 1";

      focus.mouseWarping = "container";
      menu = lib.mkDefault "'${lib.getExe config.programs.fuzzel.package}' --show-actions";
      bindkeysToCode = true; # workaround for multilayout setups
    };
    extraConfig = lib.concatStringsSep "\n\n" [
      "for_window [app_id=\"dragon-drop\"] floating enable, sticky enable"
      (lib.concatStringsSep "\n" (
        builtins.map (
          elem: "workspace number ${builtins.toString elem.workspaceNumber}; exec ${elem.command}"
        ) (lib.reverseList (lib.sortOn (x: x.workspaceNumber) config.wm-settings.workspaceBoundStartup))
      ))
      (lib.optionalString (final.package.pname == "swayfx") ''
        blur ${if config.wm-settings.beEnergyEfficient then "disable" else "enable"}
        blur_xray disable
        blur_passes 3
        blur_radius 1
        blur_noise 0
        blur_brightness 1
        blur_contrast 1
        blur_saturation 1

        shadows disable
      '')
    ];
  });

  # use commons wayland wms wallpaper program
  stylix.targets.sway.useWallpaper = false;

  imports = [
    ../wm-essentials.nix
  ]
  ++ lib'.umport {
    path = ./.;
    recursive = false;
    exclude = [ ./default.nix ];
  };
}
