{ pkgs, ... }:
{
  nixpkgs.config.rocmSupport = true; # AMDGPU support for packages

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  environment.systemPackages = with pkgs; [
    lact
  ];
}
