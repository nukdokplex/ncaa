{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{
  nixpkgs.localSystem.system = "x86_64-linux";

  imports = [
    (inputs.nixos-hardware + /common/cpu/amd)
    (inputs.nixos-hardware + /common/gpu/amd)
    (inputs.nixos-hardware + /common/pc)
    (inputs.nixos-hardware + /common/pc/ssd)
  ];

  hardware.enableRedistributableFirmware = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [
    nct6687d # MSI MAG B550 TOMAHAWK (MS-7C91) eSIO chip Nuvoton NCT66875-R
  ];

  boot.kernelModules = [ "nct6687d" ];

  # gpu staff
  nixpkgs.config.rocmSupport = true; # AMDGPU support for packages

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  environment.systemPackages = with pkgs; [
    lact
  ];
  # gpu staff

  hardware.bluetooth.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;

  programs.via.enable = true;
}
