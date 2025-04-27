{ pkgs, lib, config, ... }:
let
  cfg = config.programs.gaming-essentials;
in
{
  options.programs.gaming-essentials.enable = lib.mkEnableOption "set of essential gaming programs";

  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        full = true;
        toggle_hud = "Shift_R+F12";
        no_display = true;
      };
    };

    home.packages = with pkgs; [
      r2modman
    ];
  };
}
    
