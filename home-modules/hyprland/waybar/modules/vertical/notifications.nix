{ config, ... }:
{
  "custom/notifications" = {
    tooltip = false;
    format = "{icon}";
    format-icons = with config.lib.stylix.colors; {
      notification = "<span foreground='${withHashtag.base08}'><sup></sup></span>";
      none = "";
      dnd-notification = "<span foreground='${withHashtag.base08}'><sup></sup></span>";
      dnd-none = "";
      inhibited-notification = "<span foreground='${withHashtag.base08}'><sup></sup></span>";
      inhibited-none = "";
      dnd-inhibited-notification = "<span foreground='${withHashtag.base08}'><sup></sup></span>";
      dnd-inhibited-none = "";
    };
    return-type = "json";
    exec-if = "which swaync-client";
    exec = "swaync-client -swb";
    on-click = "swaync-client -t -sw";
    on-click-right = "swaync-client -d -sw";
    escape = true;
  };
}
