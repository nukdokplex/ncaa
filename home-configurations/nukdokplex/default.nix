{
  pkgs,
  config,
  ezModules,
  lib',
  ...
}:
{
  imports =
    [
      ezModules.common
    ]
    ++ (lib'.umport {
      path = ./.;
      exclude = [ ./default.nix ];
      recursive = false;
    });

  home = {
    username = "nukdokplex";
    stateVersion = "25.05";
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
