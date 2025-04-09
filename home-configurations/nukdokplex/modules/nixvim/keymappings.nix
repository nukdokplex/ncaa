{ lib, config, ... }: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps =
      let
        normal = lib.mapAttrsToList
          (key: action: {
            mode = "n";
            inherit key action;
          })
          {
            # space doesn't do anything
            "<Space>" = "<NOP>";

            # Esc to clear search results
            "<esc>" = ":noh<CR>";

            # close by Ctrl+x
            "<C-x>" = ":close<CR>";

            # save by Space+s or Ctrl+s
            "<leader>s" = ":w<CR>";
            "<C-s>" = ":w<CR>";

            # navigate to left/right window
            "<leader>h" = "<C-w>h";
            "<leader>l" = "<C-w>l";

            # press H and L to jump to start and end (first and last character) respectively
            "L" = "$";
            "H" = "^";
          };
        visual = lib.mapAttrsToList
          (key: action: {
            mode = "v";
            inherit key action;
          })
          { };
      in
      config.lib.nixvim.keymaps.mkKeymaps { options.silent = true; } (normal ++ visual);
  };
}
