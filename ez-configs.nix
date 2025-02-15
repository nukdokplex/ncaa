{ inputs, ... }: {
  imports = [ inputs.ez-configs.flakeModule ];
  ezConfigs = {
    globalArgs = { 
      inherit inputs;
      flakeRoot = ./.;
    };
    root = ./.;
    nixos.hosts = {
      sleipnir.userHomeModules = [ "nukdokplex" ];
      gladr.userHomeModules = [ "nukdokplex" ];
      test-vm.userHomeModules = [ "nukdokplex" ];
    };
  };
}
    
