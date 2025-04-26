{  pkgs, config, ezModules, inputs, ... }: {
  imports = [
    ezModules.common
  ] ++ (inputs.self.lib.umport {
    path = ./modules;
  });

  home = {
    username = "nukdokplex";
    stateVersion = "25.05";
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
