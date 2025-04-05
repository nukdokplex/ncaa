{ inputs, ezModules, ... }: {
  imports = [ ] ++ inputs.self.lib.umport {
    path = ./modules;
    recursive = false;
  };
}
