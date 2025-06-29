{
  inputs,
  pkgs,
  config,
  ...
}:
let
  nixvimPackage = pkgs.nixvim-custom;
  nixvim =
    if config.stylix.enable && config.stylix.targets.nixvim.enable then
      nixvimPackage.extend config.lib.stylix.nixvim.config
    else
      nixvimPackage;
in
{
  environment.systemPackages = [ nixvim ];
  stylix.targets.nixvim.transparentBackground.main = true;
}
