{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.home.isDesktop {
    programs.foot = {
      enable = true;
      settings = {
        mouse = {
          hide-when-typing = "yes";
        };

        key-bindings =
          let
            mod = "Mod1";
          in
          {
            clipboard-paste = "Control+Shift+v XF86Paste ${mod}+P";
            clipboard-copy = "Control+Shift+c XF86Copy ${mod}+Y";
          };
      };
    };
    home.sessionVariables.TERMINAL = "foot";

    # workaround for .desktop files with Terminal=true
    # xdg-open has a hardcoded list of terminals
    xdg.configFile."xdg-terminals.list".text = ''
      foot.desktop
    '';

    xdg.dataFile."xdg-terminals/foot.desktop".source = "${pkgs.foot}/share/applications/foot.desktop";
  };
}
