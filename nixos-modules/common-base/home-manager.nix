{ config, lib, ... }:
{
  home-manager = {
    useGlobalPkgs = false;
    backupFileExtension = "hm-bak";
    sharedModules = lib.singleton {
      nixpkgs = {
        inherit (config.nixpkgs) config overlays;
      };
    };
  };

  stylix.homeManagerIntegration = {
    autoImport = true;
    followSystem = true;
  };
}
