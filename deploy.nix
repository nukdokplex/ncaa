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
        user = "root";
        path = deploy-rs.lib."${deploySystem}".activate.nixos host;
      };
    };
in
{
  flake.deploy = {
    nodes = lib.recursiveUpdate (lib.genAttrs deployableSystems genDeployableSystem) {
      # custom config goes here
    };
  };

  perSystem =
    { system, ... }:
    {
      checks = deploy-rs.lib."${system}".deployChecks config.flake.deploy;
    };
}
