{
  pkgs,
  ...
}:
{
  programs.k3b-custom.enable = true;
  environment.systemPackages = with pkgs; [
    udftools
    cdrtools
    cdrdao
    cdrkit
    dvdplusrwtools
    brasero
  ];
}
