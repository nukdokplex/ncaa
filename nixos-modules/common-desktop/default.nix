{ inputs, ezModules, ... }:
{
  imports =
    [
      ezModules.common-base
    ]
    ++ inputs.self.lib.umport {
      path = ./modules;
      recursive = false;
      exclude = [ ./modules/hyprland.nix ];
    };
}
