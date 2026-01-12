{ config, ... }:
{
  clock = {
    calendar = {
      format = with config.lib.stylix.colors; {
        today = "<span color='${withHashtag.base08}'><b><u>{}</u></b></span>";
      };
      mode = "month";
      mode-mon-col = 3;
      on-click-right = "mode";
      on-scroll = 1;
      weeks-pos = "right";
    };
    format = "{:%H:%M:%S}";
    interval = 1;
    tooltip-format = "<tt><small>{calendar}</small></tt>";
  };
}
