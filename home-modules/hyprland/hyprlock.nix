{ lib, config, ... }:
let
  cfg = config.wayland.windowManager.hyprland;
in
{
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    programs.hyprlock = {
      enable = true;
      settings = with config.lib.stylix.colors; {
        general = {
          disable_loading_bar = true;
          grace = 10;
          hide_cursor = true;
          no_fade_in = false;
        };

        input-field = lib.mkForce {
          rounding = 0;
          placeholder_text = "<i>$LAYOUT</i>";
          position = "0, -120";
          valign = "center";
          halign = "center";
          outer_color = "rgb(${base03})";
          inner_color = "rgb(${base00})";
          font_color = "rgb(${base05})";
          fail_color = "rgb(${base08})";
          check_color = "rgb(${base0A})";
        };

        label = [
          {
            text = "$TIME";
            font_size = 120;
            position = "0, 80";
            valign = "center";
            halign = "center";
            color = "rgb(${base05})";
          }
        ];
      };
    };
  };
}
