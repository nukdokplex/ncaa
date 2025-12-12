{
  lib',
  lib,
  ezModules,
  inputs,
  config,
  ...
}:
{
  imports =
    lib'.umport {
      path = ./.;
      exclude = [ ./default.nix ];
      recursive = false;
    }
    ++ (with ezModules; [
      base-system
      nukdokplex
    ]);

  time.timeZone = "Europe/Moscow";
  system.stateVersion = "25.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnNGUSphRtp3azpcSzvO2Tlm75fmn0YbyEzB9Oa6sLb root@gler";

  nixpkgs.overlays = lib.singleton inputs.self.overlays.light-packages;

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.nukdokplex.openssh.authorizedKeys.keys;
}
