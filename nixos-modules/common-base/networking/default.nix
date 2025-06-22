{
  lib,
  config,
  inputs,
  ...
}:
{
  networking = {
    firewall.enable = false; # nixos firewall will conflict with custom nftables

    nftables = {
      enable = true;
      rulesetFile = ./nftables.rules;
      tables = {
        filter = {
          enable = true;
          family = "inet";
          content = "";
        };
        nat = {
          enable = true;
          family = "inet";
          content = "";
        };
      };
    };
  };
}
