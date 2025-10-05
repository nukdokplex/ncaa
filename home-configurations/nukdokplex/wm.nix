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
            "1,  defaultName:coding, default:true"
            # "2,  defaultName:"
            # "3,  defaultName:"
            "4,  defaultName:files"
            # "5,  defaultName:"
            # "6,  defaultName:"
            # "7,  defaultName:"
            # "8,  defaultName:"
            "9,  defaultName:gaming"
            "10, defaultName:video"
            "11, defaultName:browsing, default:true"
            "12, defaultName:messaging"
            # "13, defaultName:"
            # "14, defaultName:"
            "15, defaultName:email"
            # "16, defaultName:"
            "17, defaultName:password"
            # "18, defaultName:"
            # "19, defaultName:"
            "20, defaultName:music"
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
