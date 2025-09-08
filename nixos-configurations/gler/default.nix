{
  lib',
  lib,
  ezModules,
  inputs,
  ...
}:
{
  imports =
    lib'.umport {
      path = ./.;
      exclude = [ ./default.nix ];
      recursive = false;
    }
    ++ [
      ezModules.common-base
      ezModules.nixos-autoupgrade
      ezModules.acme
      inputs.simple-nixos-mailserver.nixosModule
    ];

  time.timeZone = "Europe/Moscow";
  system.stateVersion = "25.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnNGUSphRtp3azpcSzvO2Tlm75fmn0YbyEzB9Oa6sLb root@gler";

  nixpkgs.overlays = lib.singleton inputs.self.overlays.light-packages;
}
