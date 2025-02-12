{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.common.base.enable {
    console = {
      enable = true;
      earlySetup = true;
      font = "${pkgs.powerline-fonts}/share/consolefonts/ter-powerline-v32n.psf.gz";
      packages = [ pkgs.powerline-fonts ];
      keyMap = lib.mkDefault "ru";
    };
  };
}
