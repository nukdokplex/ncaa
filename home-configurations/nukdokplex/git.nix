{ config, ... }:
{
  programs.git = {
    enable = true;
    userName = "nukdokplex";
    userEmail = "nukdokplex@nukdokplex.ru";
    signing = {
      format = "openpgp";
      signByDefault = true;
      key = config.programs.git.userEmail;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
      gui = {
        language = "en";
      };
      git = {
        autoFetch = false;
        overrideGpg = true; # allow operations which require passphrase
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = false;
    settings = {
      git_protocol = "ssh";
    };
  };
}
