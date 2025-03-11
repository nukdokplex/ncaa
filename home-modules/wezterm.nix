{ config, lib, ... }: let 
  cfg = config.programs.wezterm;
in {
  options.programs.wezterm = {
    enableSessionVariablesIntegration = lib.mkOption rec {
      default = true;
      example = !default;
      description = "Whether to enable home-manager session variables integration.";
      type = lib.types.bool;
    };
  };

  config.home.sessionVariables = lib.mkIf (cfg.enable && cfg.enableSessionVariablesIntegration) {
    TERM = "wezterm";
    TERMINAL = "wezterm";
  };
}

      
