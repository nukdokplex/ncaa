{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = lib.singleton (
    pkgs.nixvim-custom.extend config.stylix.targets.nixvim.exportedModule
  );

  stylix.targets.nixvim = {
    transparentBackground.main = true;
  };
}
