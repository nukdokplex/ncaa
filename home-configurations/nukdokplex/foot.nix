{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.home.isDesktop {
    programs.foot = {
      enable = true;
      settings = {
        main.font = "IosevkaTerm Nerd Font:size=${toString (config.stylix.fonts.sizes.terminal or 12)}";
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

    xdg.terminal-exec = {
      enable = lib.mkDefault true;
      settings = {
        default = [ "foot.desktop" ];
        GNOME = [ "foot.desktop" ];
      };
    };
    home.sessionVariables.TERMCMD = "foot";
  };
}
