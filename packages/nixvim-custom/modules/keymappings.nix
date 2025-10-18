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

            "<leader>h" = ''<cmd>Telescope harpoon marks<CR>'';

            "<Tab>" = ">>";
            "<S-Tab>" = "<<";

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
    (lib.nixvim.keymaps.mkKeymaps { options.silent = true; } (normal ++ visual ++ insert))
    ++ [
      {
        mode = "v";
        key = "<Tab>";
        action = ">gv";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<S-Tab>";
        action = "<gv";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];

  plugins.barbar.keymaps = lib.mapAttrs (_: value: { key = value; }) {
    previous = "<C-j>";
    next = "<C-k>";

    movePrevious = "<C-h>";
    moveNext = "<C-l>";

    pin = "<C-n>";
    restore = "<S-n>";

    close = "<A-x>";
    closeAllButCurrentOrPinned = "<A-X>";
  };

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
