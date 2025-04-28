{
  inputs,
  pkgs,
  config,
  ...
}:
let
  nixvim = inputs.self.packages.${pkgs.system}.nixvim.extend config.lib.stylix.nixvim.config;
in
{
  environment.systemPackages = [ nixvim ];
  stylix.targets.nixvim.transparentBackground.main = true;
}
