{
  programs.nixvim.enable = true;
  imports = [
    ./plugins
    ./keymappings.nix
    ./autoCmd.nix
  ];
}
