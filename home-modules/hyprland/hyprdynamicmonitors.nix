{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.hyprdynamicmonitors.homeManagerModules.hyprdynamicmonitors
  ];

  home.packages = [ config.home.hyprdynamicmonitors.package ];

  home.hyprdynamicmonitors = {
    enable = true;
    systemdTarget = "hyprland-session.target";
  };

  wayland.windowManager.hyprland = {
    extraConfig = lib.mkAfter ''
      source = ~/.config/hypr/monitors.conf
    '';
  };
}
