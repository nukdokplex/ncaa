{ pkgs, ... }:
{
  # programs.git = {
  #   enable = true;
  #   settings = {
  #     user = {
  #       name = "nukdokplex";
  #       email = "nukdokplex@nukdokplex.ru";
  #     };
  #   };
  #   signing = {
  #     format = "ssh";
  #     signByDefault = true;
  #     key = config.programs.git.settings.user.email;
  #   };
  # };

  home.packages = with pkgs; [
    git
  ];

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
