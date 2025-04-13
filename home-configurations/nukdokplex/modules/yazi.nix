{ lib, config, pkgs, ... }: {
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
  };
}
