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
      ezModules.acme
      ezModules.nukdokplex
      inputs.simple-nixos-mailserver.nixosModule
    ];

  time.timeZone = "Europe/Moscow";
  system.stateVersion = "25.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnNGUSphRtp3azpcSzvO2Tlm75fmn0YbyEzB9Oa6sLb root@gler";

  nixpkgs.overlays = lib.singleton inputs.self.overlays.light-packages;

  user.users.root.openssh.authorizedKeys.keyFiles = [
    /etc/ssh/authorized_keys.d/nukdokplex
  ];
}
