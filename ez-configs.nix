{ inputs, config, ... }: {
  ezConfigs = {
    globalArgs = { 
      inherit inputs;
      flakeRoot = ./.;
    };
    root = ./.;
    nixos.hosts = {
      sleipnir.userHomeModules = [ "nukdokplex" ];
      gladr.userHomeModules = [ "nukdokplex" ];
      gler.userHomeModules = [ "nukdokplex" ];
    };
  };
}
    
