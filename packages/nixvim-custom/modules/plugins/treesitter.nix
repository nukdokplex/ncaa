{ pkgs, ... }:
{
  plugins.treesitter = {
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
      toml
      vim
      vimdoc
      xml
      yaml
    ];
  };
}
