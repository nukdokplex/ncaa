{ lib, config, ... }:
{
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  keymaps =
    let
      normal =
        lib.mapAttrsToList
          (key: action: {
            mode = "n";
            inherit key action;
          })
          {
            # space doesn't do anything
            "<Space>" = "<NOP>";

            # Esc to clear search results
            "<Esc>" = ":noh<CR>";

            # close by Ctrl+x
            "<C-x>" = ":close<CR>";

            # save by Space+s or Ctrl+s
            "<leader>s" = ":w<CR>";
            "<C-s>" = ":w<CR>";

            # format with lsp-format
            "<leader>f" = ":Format";

            # navigate through windows
            "<leader>h" = "<C-w>h";
            "<leader>j" = "<C-w>j";
            "<leader>k" = "<C-w>k";
            "<leader>l" = "<C-w>l";

            "L" = "$";
            "H" = "^";
          };
      visual = lib.mapAttrsToList (key: action: {
        mode = "v";
        inherit key action;
      }) { };
      insert = lib.mapAttrsToList (key: action: {
        mode = "i";
        inherit key action;
      }) { };
    in
    lib.nixvim.keymaps.mkKeymaps { options.silent = true; } (normal ++ visual ++ insert)
    ++ [
      (lib.fix (self: {
        mode = "i";
        key = "<Esc>";
        action = self.key;
        options = {
          silent = true;
          noremap = true;
        };
      }))
    ];
}
