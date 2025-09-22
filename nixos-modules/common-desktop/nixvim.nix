{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = lib.singleton (
    pkgs.nixvim-custom.extend config.lib.stylix.nixvim.config
  );

  stylix.targets.nixvim = {
    transparentBackground.main = true;
  };
}
