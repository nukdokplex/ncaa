{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ brasero ];
  programs.optical-disk-essentials.enable = true;
  programs.k3b-custom.enable = true;
}
