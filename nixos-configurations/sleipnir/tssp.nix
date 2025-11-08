{ pkgs, inputs, ... }:
{
  imports = [ inputs.tssp.nixosModules.default ];

  services.turing-smart-screen-python = {
    enable = true;
    stopOnSleep = true;
    fonts = with pkgs.tsspPackages.resources.fonts; [
      geforce
      generale-mono
      jetbrains-mono
      racespace
      roboto
      roboto-mono
    ];
    themes = with pkgs.tsspPackages.resources.themes; [
      LandscapeEarth
      Landscape6Grid
    ];
    settings = {
      config = {
        COM_PORT = "AUTO";
        THEME = "Landscape6Grid";
        HW_SENSORS = "PYTHON";
        ETH = "enp42s0";
        WLO = "enp5s0";
        CPU_FAN = "AUTO";
      };
      display = {
        REVISION = "A";
        BRIGHTNESS = 20;
        DISPLAY_REVERSE = false;
      };
    };
  };
}
