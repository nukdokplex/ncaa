{ lib, config, ... }: {
  programs.foot = {
    enable = lib.mkDefault config.home.isDesktop;
    settings = {
      colors.alpha = lib.mkForce "0.7";
      mouse = {
        hide-when-typing = "yes";
      };

      key-bindings = let mod = "Mod1"; in {
        clipboard-paste = "Control+Shift+v XF86Paste ${mod}+P";
        clipboard-copy =  "Control+Shift+c XF86Copy ${mod}+Y";
      };
    };
  };
}
