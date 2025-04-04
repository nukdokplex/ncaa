{ pkgs, lib, config, ... }: {
  console = {
    enable = true;
    earlySetup = true;
    font = "${pkgs.powerline-fonts}/share/consolefonts/ter-powerline-v24n.psf.gz";
    packages = [ pkgs.powerline-fonts ];
    keyMap = lib.mkDefault "ru";
  };
}
