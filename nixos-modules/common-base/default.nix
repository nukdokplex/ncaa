{ inputs, ezModules, ... }: {
  imports = [
    ezModules.secrets
  ] ++ inputs.self.lib.umport {
    path = ./modules;
    recursive = false;
  };
}
