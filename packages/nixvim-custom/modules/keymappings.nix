{ lib, ... }:
{
  globals = {
    mapleader = " ";
    maplocalleader = ",";
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
            # make sure leaders are not busy
            "<Space>" = "<NOP>";
            "<Tab>" = "<NOP>";

            # clear search results
            "<Esc>" = "<cmd>nohlsearch<CR>";

            # format with lsp-format
            "<leader>f" = "<cmd>Format<CR>";

            "<leader>N" = "<cmd>Yazi cwd<CR>";
            "<leader>n" = "<cmd>Yazi<CR>";
            "<leader>gi" = "<cmd>LazyGit<CR>";
            "<leader>gf" = "<cmd>LazyGitCurrentFile<CR>";

            # navigate through windows
            "<M-h>" = "<C-w>h";
            "<M-j>" = "<C-w>j";
            "<M-k>" = "<C-w>k";
            "<M-l>" = "<C-w>l";

            # harpoon file stuff
            "<C-a>".__raw = ''function() require("harpoon"):list():add() end'';

            "<C-J>".__raw = ''function() require("harpoon"):list():prev() end'';
            "<C-K>".__raw = ''function() require("harpoon"):list():next() end'';
            "<leader>j".__raw = ''function() require("harpoon"):list():prev() end'';
            "<leader>k".__raw = ''function() require("harpoon"):list():next() end'';

            "<C-h>".__raw = ''function() require("harpoon"):list():prev() end'';

            "<C-Esc>".__raw = ''function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end'';

            "<leader>h" = ''<cmd>Telescope harpoon marks<CR>'';

            # comfortable home and end
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
    lib.nixvim.keymaps.mkKeymaps { options.silent = true; } (normal ++ visual ++ insert);

  plugins.lsp.keymaps = {
    silent = true;
    diagnostic = {
      # Navigate in diagnostics
      "<leader>k" = "goto_prev";
      "<leader>j" = "goto_next";
    };

    lspBuf = {
      K = "hover";
      gD = "references";
      gd = "definition";
      gi = "implementation";
      gt = "type_definition";
    };
  };
}
