{ lib, ... }:
{
  programs.nixvim = {
    opts = lib.fix (opts: {
      # indent settings
      autoindent = true; # Maintains the indentation of the current line when starting a new line.
      smartindent = true; # Enhances autoindent by recognizing syntax (like braces in C-like languages).
      expandtab = true; # Converts tabs to spaces.
      tabstop = 2; # Sets the width of a tab character (in spaces).
      softtabstop = opts.tabstop; # Controls how many spaces a tab "feels like" when editing (mixing tabs & spaces).
      shiftwidth = opts.tabstop; # Determines the number of spaces used for auto-indentation and >>/<< shifting.
      shiftround = true; # Rounds indentation to multiples of shiftwidth when shifting with << or >>.
      breakindent = true; # Wrapped lines continue visually indented.
    });
  };
}
