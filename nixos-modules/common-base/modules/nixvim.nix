{
  inputs,
  pkgs,
  config,
  ...
}:
let
  nixvim =
    if config.stylix.enable && config.stylix.targets.nixvim.enable then
      inputs.self.packages.${pkgs.system}.nixvim.extend config.lib.stylix.nixvim.config
    else
      inputs.self.packages.${pkgs.system}.nixvim;
in
{
  environment.systemPackages = [ nixvim ];
  stylix.targets.nixvim.transparentBackground.main = true;
}
