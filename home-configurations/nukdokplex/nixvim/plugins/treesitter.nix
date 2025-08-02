{ pkgs, ... }:
{
  programs.nixvim.plugins.treesitter = {
    enable = true;
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      c
      json
      lua
      make
      markdown
      nix
      regex
      rust
      toml
      python
      vim
      vimdoc
      xml
      yaml
    ];
  };
}
