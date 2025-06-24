{
  lib,
  config,
  pkgs,
  ...
}:
{
  config =
    lib.mkIf
      (builtins.elem true (
        with config.programs;
        [
          sway.enable
          hyprland.enable
        ]
      ))
      {
        home-manager.sharedModules = lib.singleton (
          { ezModules, lib, ... }:
          {
            imports =
              (lib.optional config.programs.sway.enable ezModules.sway)
              ++ (lib.optional config.programs.hyprland.enable ezModules.hyprland);
          }
        );

        environment.systemPackages = with pkgs; [
          nautilus
        ];

        services.dbus.packages = with pkgs; [
          nautilus
        ];

        services.gnome.sushi.enable = true;
        programs.nautilus-open-any-terminal = {
          enable = true;
          terminal = "foot";
        };

        security.pam.services.hyprlock = lib.mkIf config.programs.hyprland.enable { };
        security.pam.services.swaylock = lib.mkIf config.programs.sway.enable { };
      };
}
