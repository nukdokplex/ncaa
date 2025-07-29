{
  lib,
  lib',
  pkgs,
  osConfig ? { },
  ...
}:
let
  finalPackage = osConfig.programs.niri.package or pkgs.niri;
in
{
  home.packages = [ finalPackage ];

  xdg.portal = {
    enable = lib.mkDefault true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    configPackages = [ finalPackage ];
  };

  systemd.user.targets.niri-session = {
    Unit = {
      Description = "Niri compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  imports = [
    ../wm-essentials.nix
  ]
  ++ lib'.umport {
    path = ./.;
    exclude = [ ./default.nix ];
  };
}
