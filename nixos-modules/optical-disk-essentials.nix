{ pkgs, config, lib, ... }: {
  options.programs.optical-disk-essentials.enable = lib.mkEnableOption "set of essential programs to work with optical disks (CD, DVD, BluRay)";
  config = lib.mkIf config.programs.optical-disk-essentials.enable {
    environment.systemPackages = with pkgs; [
      udftools
      cdrtools
      cdrdao
      cdrkit
      dvdplusrwtools
    ];
  };
}
