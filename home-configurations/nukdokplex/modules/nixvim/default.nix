{
  programs.nixvim.enable = true;
  imports = [
    ./plugins
    ./keymappings.nix
    ./autoCmd.nix
  ];
  stylix.targets.nixvim.transparentBackground.main = true;
}
