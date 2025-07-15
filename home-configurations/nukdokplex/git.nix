{ lib, ... }:
{
  programs.git = lib.fix (git: {
    enable = true;
    userName = "nukdokplex";
    userEmail = "nukdokplex@nukdokplex.ru";
    signing = {
      format = "openpgp";
      signByDefault = true;
      key = git.userEmail;
    };
  });

  programs.lazygit = {
    enable = true;
    settings = {
      # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
      gui = {
        language = "en";
      };
      git = {
        autoFetch = false;
      };
    };
  };
}
