{ inputs, pkgs, ... }:
{
  services.turing-smart-screen-python = {
    enable = true;
    systemd.enable = true;
    fonts = with inputs.tssp.packages.${pkgs.system}.resources.fonts; [
      geforce
      generale-mono
      jetbrains-mono
      racespace
      roboto
      roboto-mono
    ];
    themes = with inputs.tssp.packages.${pkgs.system}.resources.themes; [
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
