{ lib, config, ... }: let
  cfg = config.wayland.windowManager.sway;
  createWorkspaceBoundStartup = workspace: command: {
    always = false;
    command = "swaymsg \"workspace number ${workspace}; exec ${command}\"";
  };
in {
  wayland.windowManager.sway.config = {
    terminal = "wezterm";
    input = {
      "type:keyboard" = {
        xkb_layout = "us,ru";
        xkb_options = "grp:ctrl_space_toggle,compose:ralt";
      };
    };
    keybindings = with cfg.config; with cfg.programs; {
      "${modifier}+u" = "exec '${webBrowser}'";
      "${modifier}+o" = "exec '${fileManager}'";
    };
    startup = with cfg.programs; lib.mkAfter [
      (createWorkspaceBoundStartup "1" "'${webBrowser}'")
      (createWorkspaceBoundStartup "2" "ayugram-desktop")
      (createWorkspaceBoundStartup "2" "vesktop")
      (createWorkspaceBoundStartup "4" "'${fileManager}'")
      (createWorkspaceBoundStartup "5" "thunderbird")
      (createWorkspaceBoundStartup "7" "keepassxc")
      (createWorkspaceBoundStartup "10" "spotify") 
      { command = "swaymsg workspace number 1"; } # bring back to default workspace after spawns
    ];
    assigns = {
      "2" = [{ class = "vesktop"; }];
    };
    floating.criteria = [
      { class = "steam"; title = "^(?!Steam$).*"; } # make all secondary steam windows floating
    ];
  };
}
