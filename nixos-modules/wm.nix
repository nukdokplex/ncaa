{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  isAnyWMEnabled = (
    lib.foldl (acc: elem: acc || elem) false (
      with config;
      [
        programs.hyprland.enable
        programs.sway.enable
        programs.niri.enable
      ]
    )
  );
in
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  config = lib.mkMerge [
    (lib.mkIf isAnyWMEnabled {
      # common wm configuration goes here
      environment.systemPackages = with pkgs; [
        nautilus
        file-roller
      ];
      services = {
        dbus.packages = with pkgs; [
          nautilus
          file-roller
        ];
        gnome.sushi.enable = true;
      };
      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "foot";
      };
    })

    (lib.mkIf config.programs.hyprland.enable {
      # hyprland-specific configuration goes here
      home-manager.sharedModules = lib.singleton (
        { ezModules, ... }:
        {
          imports = [ ezModules.hyprland ];
        }
      );

      security.pam.services.hyprlock = { };
    })
  ];
}
