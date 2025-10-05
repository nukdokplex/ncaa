{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.home.isDesktop {
    wm-settings.defaultApplications = {
      webBrowser = config.programs.firefox.finalPackage;
      fileManager = pkgs.nautilus;
      mailClient = pkgs.thunderbird;
      passwordManager = pkgs.keepassxc;
      terminal = config.programs.foot.package;
    };

    wayland.windowManager =
      let
        kb_layout = "us,ru";
        kb_options = "grp:ctrl_space_toggle,compose:ralt";
      in
      {
        hyprland.settings = {
          workspace = [
            "1,  persistent:true, defaultName:coding"
            "2,  persistent:true, defaultName:files"
            "3,  persistent:true, defaultName:email"
            "4,  persistent:true, defaultName:gaming"
            "5,  persistent:true, defaultName:video"
            "6,  persistent:true, defaultName:browsing"
            "7,  persistent:true, defaultName:messaging"
            "8,  persistent:true, defaultName:password"
            "9,  persistent:true, defaultName:reserved"
            "10, persistent:true, defaultName:music"
          ];

          exec-once = lib.mkAfter [
            "[workspace name:coding silent] ${lib.getExe config.wm-settings.defaultApplications.terminal}"
            "[workspace name:files silent] ${lib.getExe config.wm-settings.defaultApplications.fileManager}"
            "[workspace name:browsing silent] ${lib.getExe config.wm-settings.defaultApplications.webBrowser}"
            "[workspace name:email silent] ${lib.getExe config.wm-settings.defaultApplications.mailClient}"
            "[workspace name:password silent] ${lib.getExe config.wm-settings.defaultApplications.passwordManager}"
            "[workspace name:video silent] vlc"
            "[workspace name:messaging silent] vesktop"
            "[workspace name:messaging silent] AyuGram"
            "[workspace name:music silent] spotify"
            "[workspace name:gaming silent] steam"
          ];

          windowrule = [
            # these applications are opening their windows multiple times
            "workspace name:messaging, class:vesktop"
            "workspace name:gaming, class:steam"
          ];

          input = {
            inherit kb_layout kb_options;
          };
        };
        sway.config.input."type:keyboard" = {
          xkb_layout = kb_layout;
          xkb_options = kb_options;
        };
      };
  };
}
