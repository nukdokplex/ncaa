{
  autoCmd = [
    {
      # vertically center document when entering insert mode
      event = "InsertEnter";
      command = "norm zz";
    }
    {
      # open help in a vertical split
      event = "FileType";
      pattern = "help";
      command = "wincmd L";
    }
    {
      # enable spellcheck for some filetypes
      event = "FileType";
      pattern = [
        "markdown"
      ];
      command = "setlocal spell spelllang=en";
    }
  ];
}
