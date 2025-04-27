{ config, pkgs, lib, ... }:
let
  cfg = config.programs.k3b-custom;
in
{
  options.programs.k3b-custom = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable k3b, the KDE disk burning application.
        This NixOS module also provides package option and uses
        `kdePackages.k3b` by default.

        Additionally to installing `k3b` enabling this will
        add `setuid` wrappers in `/run/wrappers/bin`
        for both `cdrdao` and `cdrecord`. On first
        run you must manually configure the path of `cdrdae` and
        `cdrecord` to correspond to the appropriate paths under
        `/run/wrappers/bin` in the "Setup External Programs" menu.
      '';
    };

    package = lib.mkPackageOption pkgs.kdePackages "k3b" {
      pkgsText = "pkgs.kdePackages";
      example = "pkgs.libsForQt5.k3b";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.package
      dvdplusrwtools
      cdrdao
      cdrtools
    ];

    security.wrappers = {
      cdrdao = {
        setuid = true;
        owner = "root";
        group = "cdrom";
        permissions = "u+rwx,g+x";
        source = lib.getExe' pkgs.cdrdao "cdrdao";
      };
      cdrecord = {
        setuid = true;
        owner = "root";
        group = "cdrom";
        permissions = "u+rwx,g+x";
        source = lib.getExe' pkgs.cdrtools "cdrecord";
      };
    };
  };
}
