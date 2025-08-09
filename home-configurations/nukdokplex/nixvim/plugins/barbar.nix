{
  programs.nixvim = {
    plugins.barbar = {
      enable = true;
      keymaps = {
        previous.key = "<M-J>";
        next.key = "<M-K>";
        close.key = "<M-x>";
        closeAllButCurrentOrPinned.key = "<M-X>";
        pin.key = "<leader>V";
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<M-C-x>";
        action = "BufferClose!";
        options.silent = true;
      }
    ];
  };
}
