{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (inputs) deploy-rs;
  deploySystem = "x86_64-linux"; # boo, deploy-rs, boo!!!

  deployableSystems = [
    "falhofnir"
    "gladr"
    "gler"
    "holl"
    "sleipnir"
  ];

  genDeployableSystem =
    hostName:
    let
      host = inputs.self.outputs.nixosConfigurations.${hostName};
    in
    {
      hostname = "${host.config.networking.hostName}.ndp.local";
      profiles.system = {
        sshUser = "nukdokplex";
        user = "root";
        interactiveSudo = true;
        autoRollback = true;
        path = deploy-rs.lib."${deploySystem}".activate.nixos host;
      };
    };
in
{
  flake.deploy = {
    nodes = lib.recursiveUpdate (lib.genAttrs deployableSystems genDeployableSystem) {
      sleipnir = {
        remoteBuild = true;
      };
    };
  };

  perSystem =
    { system, ... }:
    {
      checks = deploy-rs.lib."${system}".deployChecks config.flake.deploy;
    };
}
