{ lib, ... }:
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

            "<C-x>" = ":close<CR>";
            "<M-x>" = ":clode<CR>";

            # format with lsp-format
            "<leader>f" = ":Format<CR>";

            "<leader>n" = "<cmd>Yazi cwd<CR>";
            "<leader>gi" = "<cmd>LazyGit<CR>";
            "<leader>gf" = "<cmd>LazyGitCurrentFile<CR>";

            # navigate through windows
            "<M-h>" = "<C-w>h";
            "<M-j>" = "<C-w>j";
            "<M-k>" = "<C-w>k";
            "<M-l>" = "<C-w>l";

            "L" = "$";
            "H" = "^";
          };
      visual =
        lib.mapAttrsToList
          (key: action: {
            mode = "v";
            inherit key action;
          })
          {
            "L" = "$";
            "H" = "^";
          };
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
