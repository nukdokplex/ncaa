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

    wm-settings.workspaceBoundStartup = [
      {
        workspaceNumber = 1;
        command = "'${lib.getExe config.wm-settings.defaultApplications.webBrowser}'";
      }
      {
        workspaceNumber = 2;
        command = "'${lib.getExe' pkgs.ayugram-desktop "AyuGram"}'";
      }
      {
        workspaceNumber = 2;
        command = "vesktop";
      }
      {
        workspaceNumber = 4;
        command = "'${lib.getExe config.wm-settings.defaultApplications.fileManager}'";
      }
      {
        workspaceNumber = 5;
        command = "'${lib.getExe config.wm-settings.defaultApplications.mailClient}'";
      }
      {
        workspaceNumber = 7;
        command = "'${lib.getExe config.wm-settings.defaultApplications.passwordManager}'";
      }
      {
        workspaceNumber = 10;
        command = "spotify";
      }
    ];

    wayland.windowManager.hyprland = {
      settings = {
        input = {
          kb_layout = "us,ru";
          kb_options = "grp:ctrl_space_toggle,compose:ralt";
        };

        windowrule = lib.mkAfter [
          "workspace 2 silent, class:vesktop"
          "float, class:galculator"
          "pin, class:galculator"
        ];

      };
    };

    wayland.windowManager.sway.config = {
      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:ctrl_space_toggle,compose:ralt";
        };
      };

      floating.criteria = [
        {
          class = "steam";
          title = "^(?!Steam$).*";
        } # make all secondary steam windows floating
        { class = "galculator"; }
      ];
    };
  };
}
