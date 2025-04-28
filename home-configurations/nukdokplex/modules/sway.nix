{ lib, config, ... }:
let
  cfg = config.wayland.windowManager.sway;
in
{
  wayland.windowManager.sway = {
    workspaceBoundStartup = with cfg.programs; [
      {
        workspaceNumber = 1;
        command = "'${webBrowser}'";
      }
      {
        workspaceNumber = 2;
        command = "ayugram-desktop";
      }
      {
        workspaceNumber = 2;
        command = "vesktop";
      }
      {
        workspaceNumber = 4;
        command = "'${fileManager}'";
      }
      {
        workspaceNumber = 5;
        command = "thunderbird";
      }
      {
        workspaceNumber = 7;
        command = "keepassxc";
      }
      {
        workspaceNumber = 10;
        command = "spotify";
      }
    ];

    programs.webBrowser = lib.getExe config.programs.firefox.package;

    config = {
      terminal = lib.getExe config.programs.foot.package;
      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:ctrl_space_toggle,compose:ralt";
        };
      };
      keybindings =
        with cfg.config;
        with cfg.programs;
        {
          "${modifier}+u" = "exec '${webBrowser}'";
        };
      assigns = {
        "2" = [ { class = "vesktop"; } ];
        "10" = [ { class = "Spotify"; } ];
      };
      floating.criteria = [
        {
          class = "steam";
          title = "^(?!Steam$).*";
        } # make all secondary steam windows floating
      ];
    };
  };
}
