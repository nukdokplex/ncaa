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
}
