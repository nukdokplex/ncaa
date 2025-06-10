{ lib, config, ... }@args:
let
  hostNamePath = [
    "osConfig"
    "networking"
    "hostName"
  ];
in
{
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
        placeholder_text = "<i>enter password...</i>";
        position = "0%, 0%";
        size = "20%, 8%";
        valign = "center";
        halign = "center";
        outer_color = "rgb(${base0D})";
        inner_color = "rgb(${base00})";
        font_color = "rgb(${base05})";
        fail_color = "rgb(${red})";
        check_color = "rgb(${yellow})";
      };

      label = [
        {
          text = "$TIME";
          taxt_align = "left";
          font_size = 120;
          position = "30px, -30px";
          valign = "top";
          halign = "left";
          color = "rgb(${base0D})";
          shadow_passes = 3;
        }
        {
          text =
            if lib.hasAttrByPath hostNamePath args then
              "$USER@${lib.attrByPath hostNamePath "" args}"
            else
              "$USER";
          text_align = "center";
          color = "rgb(${base05})";
          font_size = 32;
          position = "0%, 16%";
          halign = "center";
          valign = "center";
          shadow_passes = 3;
          shadow_boost = 1.4;
        }
        {
          text = "$LAYOUT";
          text_align = "center";
          color = "rgb(${base05})";
          font_size = 16;
          position = "0%, 10%";
          halign = "center";
          valign = "center";
          shadow_passes = 3;
          shadow_boost = 1.4;
        }
      ];
    };
  };
}
